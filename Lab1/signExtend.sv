`timescale 1ns / 1ps

module signExtend (
        input logic [31:0] x,
        output logic [63:0] y
);

        always @(*) begin

                if ( /* SIGN EXTENSION FOR I TYPE INSTRUCTIONS */
                (x[31:22] == 10'b1001000100) || //ADDI
                (x[31:22] == 10'b1001001000) || //ANDI
                (x[31:22] == 10'b1011001000) || //ORRI
                (x[31:22] == 10'b1101000100)    //SUBI
                ) begin

                        y = {{52{x[21]}}, x[21:10]};

                end

                else if ( /* SIGN EXTENSION FOR UNCONDITIONAL BRANCH */
                (x[31:26] == 6'b000101)
                ) begin

                  y = {{38{x[25]}}, x[25:0]};
                        
                end

                else if ( /* SIGN EXTENSION FOR CONDITIONAL BRANCH*/
                (x[31:24] == 8'b10110100) || //CBZ
                (x[31:24] == 8'b10110101)    //CBNZ
                ) begin
                        y = {{45{x[23]}}, x[23:5]};
                        
                end

                else if ( /* SIGN EXTENSION FOR LDUR/STUR OPERATIONS */
                (x[31:21] == 11'b11111000000) || //STUR
                (x[31:21] == 11'b11111000010)    //LDUR
                ) begin

                        y = {{55{x[20]}}, x[20:12]};
                        
                end

                else if ( /* SIGN EXTENSION FOR LOGICAL SHIFT OPERATIONS */
                (x[31:21] == 11'b11010011010) || //LSR
                (x[31:21] == 11'b11010011011)    //LSL
                ) begin

                        y = {{58{x[15]}}, x[15:10]};
                        
                end
                else begin
                        y = 64'hDEADBEEFDEADBEEF;
                end

        end

endmodule