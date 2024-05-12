/*  
    Program used to check the resolution of SK_module timestamp
    Example:
    (no input) writing 0xDEADBEEF to 0xFF200810
    expected output : 0x9ABCBEEF 0xFF200000 and 0x12345678 in 0xFF200001

    working version
*/
#include <sys/mman.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include "hps_0.h"
#include <stdint.h>
#include <stdlib.h>

#define HPS2FPGA_AXI_BRIDGE 0xFF200000 //FPGA Slaves Accessed Via Lightweight HPS2FPGA AXI Bridge
#define HW_REGS_SPAN SK_MODULE_0_AVALON_SLAVE_1_END //in this span we have Avalon Slave 1 & 2
#define HW_REGS_BASE HPS2FPGA_AXI_BRIDGE 
#define HW_REGS_MASK (SK_MODULE_0_AVALON_SLAVE_1_END-1)
#define DATA_SIZE 0x10 //16 bits
#define TIMESTAMP_SIZE 0x30 //48 bits
#define STEP_SIZE 0x4 
#define MESSAGE_SIZE 0x8 
#define MAP_SIZE 4096UL
#define MAP_MASK (MAP_SIZE - 1)
#define CLOCK_CYCLE_MICROSECOND 50
#define CLOCK_CYCLE 1
#define NUMBER_MESSAGES 5
#define PAIR 2
#define ARGUMENTS 3
#define SUCCESS 0 
#define FAILURE 1

#define CLK_FREQ 50000000 //50MHz

typedef struct{
    uint64_t timestamp;
    uint16_t data;
} fixed_message;

typedef struct{
    int data1;
    int data2;
} raw_message;

void execution_time(fixed_message *messages, uint8_t num)
{
    num--;
    uint64_t time;
    int i=0, summ=0;
    float average=0;
    for(i=0;i<num;i++)
    {
        time = messages[i+1].timestamp - messages[i].timestamp;
        summ+=time;
        printf("timestamp nr[%d]: %llu\n", i, time);
    }
    average=((float)summ/(float)num);
    printf("average timestamp: %.2f\n", average);
}

void cast_to_fixed_message(raw_message *raw_messages, fixed_message *fixed_messages, uint8_t num_messages)
{
    int i=0;
    for(i=0;i<num_messages;i++)
    {
        fixed_messages[i].data = (uint16_t) (raw_messages[i].data1 & 0x0000FFFF);
        fixed_messages[i].timestamp = (uint64_t) ((raw_messages[i].data1 & 0xFFFF0000)>>16); 
        fixed_messages[i].timestamp += (uint64_t) (((uint64_t) raw_messages[i].data2 )<<16);
        printf("cast to fixed message[%d]: timestamp: %llu, data: %X\n", i, fixed_messages[i].timestamp, fixed_messages[i].data);
    }
}

void collect_raw_message(uint8_t num_messages, int *input, raw_message *raw_messages, 
                    int delay_us, void *virtual_base, void *h2p_lw_write_addr, void *h2p_lw_read_addr)
{
    printf("\nstart procedure with delay: %d clock_cycles\n", delay_us);
    int i=0;

    //write messages to Avalon Slave 1
    for(i=0 ; i<num_messages ; i++)
    {
        (*(int *) h2p_lw_write_addr) = input[i];
        printf("i'm writing value: 0x%X, to an address: %p \n", input[i], h2p_lw_write_addr);
        usleep(delay_us*CLOCK_CYCLE);
    }

    //read messages from Avalon Slave 1
    i=0;
    raw_messages[i].data1 = (*(int *) h2p_lw_read_addr);
    h2p_lw_read_addr = h2p_lw_read_addr + (unsigned long) STEP_SIZE;
    raw_messages[i].data2 = (*(int *) h2p_lw_read_addr);
    printf("raw_message[%d]: word[0]=0x%X, word[1]=0x%X\n", i, raw_messages[i].data1, raw_messages[i].data2);

    for(i=1 ; i<num_messages ; i++)
    {
        h2p_lw_read_addr = h2p_lw_read_addr + (unsigned long) STEP_SIZE;
        raw_messages[i].data1 = (*(int *) h2p_lw_read_addr);
        h2p_lw_read_addr = h2p_lw_read_addr + (unsigned long) STEP_SIZE;
        raw_messages[i].data2 = (*(int *) h2p_lw_read_addr);
        printf("raw_message[%d]: word[0]=0x%X, word[1]=0x%X\n", i, raw_messages[i].data1, raw_messages[i].data2);
    } 
}

int main(int argc, char **argv)
{
    int fd;
    void *virtual_base;
    void *h2p_lw_write_addr;
    void *h2p_lw_read_addr;
    int test_var[NUMBER_MESSAGES] = {0x0000AAAA, 0x0000BBBB, 0x0000CCCC, 0x0000DDDD, 0x0000EEEE};
    int delay1=0, delay2=0;
    raw_message raw_messages[NUMBER_MESSAGES] = {{0,0}};
    fixed_message fixed_messages[NUMBER_MESSAGES] = {{0,0}};

    if ((argc < 3 ))
    {
        fprintf(stderr, "\nUsage:\t%s { delay1 } {delay2}\n"
		"\tdelay1: the period (in microseconds) between messages sent in first series to avalon slave 1\n"
        "\tdelay2: the period (in microseconds) between messages sent in second series to avalon slave 1\n\n",
		argv[0]);
		exit(1);
    }

    delay1 = atoi(argv[1]);
    delay2 = atoi(argv[2]);

    printf("read delay1: %d, delay2: %d\n", delay1, delay2);

	// map the address space 
	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( FAILURE );
	}

	virtual_base = mmap( NULL, MAP_SIZE, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE & ~MAP_MASK );

	if( virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap() failed...\n" );
		close( fd );
		return( FAILURE );
	}
   
    h2p_lw_write_addr = virtual_base + ( unsigned long )( SK_MODULE_0_AVALON_SLAVE_1_BASE & MAP_MASK);
    h2p_lw_read_addr = virtual_base + ( unsigned long )( SK_MODULE_0_AVALON_SLAVE_0_BASE & MAP_MASK);

    /*1 us delay*/
    collect_raw_message((uint8_t) NUMBER_MESSAGES, test_var, raw_messages, delay1, virtual_base, h2p_lw_write_addr, h2p_lw_read_addr);
    cast_to_fixed_message(raw_messages, fixed_messages, (uint8_t) NUMBER_MESSAGES);
    execution_time(fixed_messages, NUMBER_MESSAGES);

    h2p_lw_read_addr = h2p_lw_read_addr + (unsigned long) (MESSAGE_SIZE*NUMBER_MESSAGES);

    /*5 us delay*/
    collect_raw_message((uint8_t) NUMBER_MESSAGES, test_var, raw_messages, delay2, virtual_base, h2p_lw_write_addr, h2p_lw_read_addr);
    cast_to_fixed_message(raw_messages, fixed_messages, (uint8_t) NUMBER_MESSAGES);
    execution_time(fixed_messages, NUMBER_MESSAGES);

    if( munmap( virtual_base, HW_REGS_SPAN ) != 0 ) {
		printf( "ERROR: munmap() failed...\n" );
		close( fd );
		return( FAILURE );
	}

	close( fd );

    return SUCCESS;
}