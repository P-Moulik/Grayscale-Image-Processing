`timescale 1ns / 1ps

module imageProcessTop(
    input        i_clk,
    input        i_rst,
    input        i_data_valid,
    input  [7:0] i_data,
    output       o_data_valid,
    output [7:0] o_data
);

    wire [71:0] pixel_data;
    wire        pixel_data_valid;
    wire [7:0]  convolved_data;
    wire        convolved_data_valid;

    // Image control
    imageControl IC (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_pixel_data(i_data),
        .i_pixel_data_valid(i_data_valid),
        .o_pixel_data(pixel_data),
        .o_pixel_data_valid(pixel_data_valid),
        .o_intr() // not used in this flow
    );

    // Convolution
    conv conv_inst (
        .i_clk(i_clk),
        .i_pixel_data(pixel_data),
        .i_pixel_data_valid(pixel_data_valid),
        .o_convolved_data(convolved_data),
        .o_convolved_data_valid(convolved_data_valid)
    );

    // Directly connect outputs
    assign o_data       = convolved_data;
    assign o_data_valid = convolved_data_valid;

endmodule
