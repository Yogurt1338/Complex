#include <stdio.h>
#include <stdint.h>

// Assuming data_valid is some status where:
// 0 = no data, 1 = new data available
#define NO_DATA 0
#define NEW_DATA 1

// Function prototypes
void process_data(int8_t a_real, int8_t a_imag, int8_t b_real, int8_t b_imag);
void state_machine();

// Global variables (which preserve state across function calls)
int8_t a_real_reg = 0, a_imag_reg = 0, b_real_reg = 0, b_imag_reg = 0;
int16_t k1 = 0, k2 = 0, k3 = 0;
int16_t mult1 = 0, mult2 = 0, temp = 0;
int16_t z_real = 0, z_imag = 0;
int state = 0;

int main() {
    // In a software simulation, we'd likely be calling this in some kind of loop
    // or based on some event which indicates that there's new data to process.
    // Here's a simple example with hardcoded inputs.

    // Simulate the clock and data_valid signal
    for(int i = 0; i < 10; i++) {
        // Simulate new data coming in on every cycle
        int8_t a_real = 1, a_imag = -1, b_real = 2, b_imag = -2;
        process_data(a_real, a_imag, b_real, b_imag);
    }
    
    // Print final results
    printf("Result: Z_real: %d, Z_imag: %d\n", z_real, z_imag);
    
    return 0;
}

void process_data(int8_t a_real, int8_t a_imag, int8_t b_real, int8_t b_imag) {
    static int data_valid = NO_DATA;
    
    // Simulate a data valid signal
    data_valid = NEW_DATA;
    
    if(data_valid == NEW_DATA) {
        // Register new values
        a_real_reg = a_real;
        a_imag_reg = a_imag;
        b_real_reg = b_real;
        b_imag_reg = b_imag;
        
        // Reset or prepare other values
        k1 = k2 = k3 = 0;
        state = 1;
        data_valid = NO_DATA;
    }
    
    // Call the state machine to process the data
    state_machine();
}

void state_machine() {
    switch(state) {
        case 1:
            mult1 = (int16_t)a_real_reg;
            mult2 = (int16_t)(a_imag_reg + b_imag_reg);
            temp = mult1 * mult2;
            k2 = temp;
            state = 2;
            break;
        case 2:
            mult1 = (int16_t)b_imag_reg;
            mult2 = (int16_t)(a_real_reg + b_real_reg);
            temp = mult1 * mult2;
            k3 = temp;
            state = 3;
            break;
        case 3:
            mult1 = (int16_t)a_imag_reg;
            mult2 = (int16_t)(b_real_reg - a_real_reg);
            temp = mult1 * mult2;
            k1 = temp;
            z_real = k1 - k2;
            z_imag = k1 + k3;
            state = 0;
            break;
        default:
            break;
    }
}
