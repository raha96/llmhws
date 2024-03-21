/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : R-2020.09-SP4
// Date      : Sun May  9 12:02:11 2021
/////////////////////////////////////////////////////////////


module aes_binary ( clk, data_stable, key_ready, finished, round_type_sel, 
        test_se, RESET, test_si, test_so );
  output [1:0] round_type_sel;
  input clk, data_stable, key_ready, test_se, RESET, test_si;
  output finished, test_so;
  wire   finished, n15, n16, round_type_sel_0_, n18, n19, n20, n21, n22, n23,
         n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36, n37,
         n38, n39, n40, n41, n42, n43, n44;
  wire   [2:0] FSM;
  wire   [2:0] next_FSM;
  wire   [3:0] round_index;
  assign round_type_sel[1] = finished;
  assign test_so = round_index[3];
  assign round_type_sel[0] = round_type_sel_0_;

  SDFFSRX1 round_index_reg_0_ ( .D(n44), .SI(FSM[2]), .SE(test_se), .CK(clk), 
        .SN(1'b1), .RN(1'b1), .Q(round_index[0]), .QN(n23) );
  SDFFSRX1 round_index_reg_1_ ( .D(n42), .SI(round_index[0]), .SE(test_se), 
        .CK(clk), .SN(1'b1), .RN(1'b1), .Q(round_index[1]), .QN(n22) );
  SDFFSRX1 round_index_reg_3_ ( .D(n43), .SI(round_index[2]), .SE(test_se), 
        .CK(clk), .SN(1'b1), .RN(1'b1), .Q(round_index[3]), .QN(n20) );
  SDFFSRX1 FSM_reg_2_ ( .D(next_FSM[2]), .SI(FSM[1]), .SE(test_se), .CK(clk), 
        .SN(1'b1), .RN(1'b1), .Q(FSM[2]), .QN(n16) );
  SDFFSRX1 FSM_reg_1_ ( .D(next_FSM[1]), .SI(FSM[0]), .SE(test_se), .CK(clk), 
        .SN(1'b1), .RN(1'b1), .Q(FSM[1]), .QN(n18) );
  SDFFSRX1 FSM_reg_0_ ( .D(next_FSM[0]), .SI(test_si), .SE(test_se), .CK(clk), 
        .SN(1'b1), .RN(1'b1), .Q(FSM[0]) );
  SDFFSRX1 round_index_reg_2_ ( .D(n41), .SI(round_index[1]), .SE(test_se), 
        .CK(clk), .SN(1'b1), .RN(1'b1), .Q(round_index[2]), .QN(n21) );
  INVX1 U23 ( .A(n27), .Y(n15) );
  INVX1 U24 ( .A(n35), .Y(round_type_sel_0_) );
  INVX1 U25 ( .A(n40), .Y(n19) );
  INVX1 U26 ( .A(key_ready), .Y(n24) );
  AOI21X1 U27 ( .A0(n15), .A1(n25), .B0(n24), .Y(next_FSM[2]) );
  NAND4X1 U28 ( .A(round_index[3]), .B(round_index[0]), .C(n22), .D(n21), .Y(
        n26) );
  NOR2X1 U29 ( .A(n24), .B(n28), .Y(next_FSM[1]) );
  AOI22X1 U30 ( .A0(n31), .A1(data_stable), .B0(FSM[2]), .B1(n19), .Y(n30) );
  NOR2X1 U31 ( .A(FSM[0]), .B(n18), .Y(n31) );
  OAI21X1 U32 ( .A0(round_index[2]), .A1(n32), .B0(n33), .Y(n41) );
  NAND3X1 U33 ( .A(FSM[2]), .B(n34), .C(round_index[2]), .Y(n33) );
  OAI33X1 U34 ( .A0(n35), .A1(round_index[1]), .A2(n23), .B0(n22), .B1(n36), 
        .B2(n16), .Y(n42) );
  OAI33X1 U35 ( .A0(n20), .A1(n37), .A2(n16), .B0(n32), .B1(round_index[3]), 
        .B2(n21), .Y(n43) );
  NAND3X1 U36 ( .A(round_type_sel_0_), .B(round_index[0]), .C(round_index[1]), 
        .Y(n32) );
  NOR2X1 U37 ( .A(n21), .B(n34), .Y(n37) );
  NOR2X1 U38 ( .A(n23), .B(n19), .Y(n36) );
  OAI21X1 U39 ( .A0(round_index[0]), .A1(n35), .B0(n38), .Y(n44) );
  AOI21X1 U40 ( .A0(n39), .A1(round_index[0]), .B0(n27), .Y(n38) );
  NOR2X1 U41 ( .A(n29), .B(FSM[2]), .Y(n27) );
  NOR2X1 U42 ( .A(n40), .B(n16), .Y(n39) );
  NOR2X1 U43 ( .A(n19), .B(FSM[2]), .Y(finished) );
  NOR2X1 U44 ( .A(FSM[1]), .B(FSM[0]), .Y(n40) );
  NAND2X1 U45 ( .A(FSM[2]), .B(n40), .Y(n35) );
  NAND2X1 U46 ( .A(round_index[1]), .B(n36), .Y(n34) );
  NAND2X1 U47 ( .A(round_type_sel_0_), .B(n26), .Y(n25) );
  NAND2X1 U48 ( .A(n30), .B(key_ready), .Y(next_FSM[0]) );
  NAND2X1 U49 ( .A(FSM[1]), .B(FSM[0]), .Y(n29) );
  NAND2X1 U50 ( .A(n29), .B(n16), .Y(n28) );
endmodule

