`timescale 1ns / 1ps
`define headerSize 1078          // BMP grayscale header size
`define imageSize 512*512        // assuming 512x512 image

module tb;

    reg clk;
    reg reset;
    reg [7:0] imgData;
    reg imgDataValid;
    wire [7:0] outData;
    wire outDataValid;
    integer receivedData = 0;

    integer file_in, file_out, i;

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // 100 MHz clock
    end

    // Stimulus
    initial begin
        reset = 0;
        imgDataValid = 0;
        #100 reset = 1;
        #100;

        // Open input BMP and output TXT
        file_in  = $fopen("image.bmp","rb");
        file_out = $fopen("output_pixels.txt","w");

        if (file_in == 0) begin
            $display("ERROR: Cannot open input BMP file!");
            $finish;
        end

        // Skip BMP header
        for (i = 0; i < `headerSize; i = i + 1) begin
            $fgetc(file_in);
        end

        // Feed pixel data
        for (i = 0; i < `imageSize; i = i + 1) begin
            @(posedge clk);
            if (!$feof(file_in)) begin
                imgData = $fgetc(file_in);  // read grayscale pixel (0–255)
                imgDataValid = 1'b1;
            end else begin
                imgData = 0;
                imgDataValid = 0;
            end
        end

        @(posedge clk);
        imgDataValid = 0;

        $fclose(file_in);
        $fclose(file_out);
        $stop;
    end

    // Capture output pixels
    always @(posedge clk) begin
        if (outDataValid) begin
            $fwrite(file_out, "%d\n", outData);
            receivedData = receivedData + 1;
        end
    end

    // Instantiate DUT
    imageProcessTop dut(
        .axi_clk(clk),
        .axi_reset_n(reset),
        // slave interface
        .i_data_valid(imgDataValid),
        .i_data(imgData),
        .o_data_ready(),
        // master interface
        .o_data_valid(outDataValid),
        .o_data(outData),
        .i_data_ready(1'b1),
        // interrupt
        .o_intr()
    );

endmodule
