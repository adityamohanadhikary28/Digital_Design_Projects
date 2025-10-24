//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2025.1 (win64) Build 6140274 Thu May 22 00:12:29 MDT 2025
//Date        : Tue Oct 21 19:29:27 2025
//Host        : Aditya_ASUS running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (I0_0,
    I0_1,
    I0_2,
    I0_3,
    I0_4,
    I0_5,
    I0_6,
    I0_7,
    sel_0,
    sel_1,
    sel_2,
    y_0,
    y_1,
    y_2,
    y_3,
    y_4,
    y_5,
    y_6,
    y_7);
  input I0_0;
  input I0_1;
  input I0_2;
  input I0_3;
  input I0_4;
  input I0_5;
  input I0_6;
  input I0_7;
  input sel_0;
  input sel_1;
  input sel_2;
  output y_0;
  output y_1;
  output y_2;
  output y_3;
  output y_4;
  output y_5;
  output y_6;
  output y_7;

  wire I0_0;
  wire I0_1;
  wire I0_2;
  wire I0_3;
  wire I0_4;
  wire I0_5;
  wire I0_6;
  wire I0_7;
  wire sel_0;
  wire sel_1;
  wire sel_2;
  wire y_0;
  wire y_1;
  wire y_2;
  wire y_3;
  wire y_4;
  wire y_5;
  wire y_6;
  wire y_7;

  design_1 design_1_i
       (.I0_0(I0_0),
        .I0_1(I0_1),
        .I0_2(I0_2),
        .I0_3(I0_3),
        .I0_4(I0_4),
        .I0_5(I0_5),
        .I0_6(I0_6),
        .I0_7(I0_7),
        .sel_0(sel_0),
        .sel_1(sel_1),
        .sel_2(sel_2),
        .y_0(y_0),
        .y_1(y_1),
        .y_2(y_2),
        .y_3(y_3),
        .y_4(y_4),
        .y_5(y_5),
        .y_6(y_6),
        .y_7(y_7));
endmodule