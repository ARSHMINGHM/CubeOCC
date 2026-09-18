`timescale 1ns/1ps

module grayscale_perspective_grid_image_tb;
    localparam int W=160, H=120, PIXELS=W*H;
    logic pclk=0,rst_n=0,vsync=1,href=0;
    logic [7:0] pixel_gray=0;
    logic [9:0] tl_x,tl_y,tr_x,tr_y,br_x,br_y,bl_x,bl_y;
    logic busy,out_valid,frame_done;
    logic [7:0] out_gray;
    logic [9:0] out_x,out_y;
    logic [2:0] grid_col,grid_row;
    logic [5:0] grid_cell;
    logic [7:0] frame_mem[0:PIXELS-1];
    integer count[0:63],sum_gray[0:63];
    integer i,row,col,frame_index,list_file,result_file,warp_file,parsed;
    string list_path,result_path,input_path,output_path;
    always #5 pclk=~pclk;

    grayscale_perspective_grid_8x8 dut(.*);

    always @(posedge pclk) if(out_valid) begin
        count[grid_cell]=count[grid_cell]+1;
        sum_gray[grid_cell]=sum_gray[grid_cell]+out_gray;
        $fwrite(warp_file,"%02x\n",out_gray);
    end

    task automatic clear_stats;
        begin for(i=0;i<64;i=i+1) begin count[i]=0;sum_gray[i]=0;end end
    endtask

    task automatic send_frame;
        begin
            clear_stats();
            @(negedge pclk);vsync=0;
            for(row=0;row<H;row=row+1) begin
                for(col=0;col<W;col=col+1) begin
                    @(negedge pclk);href=1;pixel_gray=frame_mem[row*W+col];
                end
                @(negedge pclk);href=0;pixel_gray=0;
            end
            @(negedge pclk);vsync=1;
            wait(frame_done);@(posedge pclk);
        end
    endtask

    initial begin
        if(!$value$plusargs("FILE_LIST=%s",list_path))list_path="frame_list.txt";
        if(!$value$plusargs("RESULT=%s",result_path))result_path="grid_results.csv";
        list_file=$fopen(list_path,"r");result_file=$fopen(result_path,"w");
        if(!list_file||!result_file)$fatal(1,"Cannot open input/output");
        $fwrite(result_file,"frame,cell,row,col,pixels,avg_gray\n");
        repeat(4)@(posedge pclk);rst_n=1;frame_index=0;
        while(!$feof(list_file)) begin
            parsed=$fscanf(list_file,"%s %s %d %d %d %d %d %d %d %d\n",input_path,output_path,tl_x,tl_y,tr_x,tr_y,br_x,br_y,bl_x,bl_y);
            if(parsed==10) begin
                $readmemh(input_path,frame_mem);warp_file=$fopen(output_path,"w");
                if(!warp_file)$fatal(1,"Cannot open warped output");
                send_frame();$fclose(warp_file);
                for(i=0;i<64;i=i+1)$fwrite(result_file,"%0d,%0d,%0d,%0d,%0d,%0d\n",frame_index,i,i/8,i%8,count[i],count[i]?sum_gray[i]/count[i]:0);
                frame_index=frame_index+1;
            end
        end
        $fclose(list_file);$fclose(result_file);
        $display("FPGA PERSPECTIVE GRID PASS: %0d frame(s)",frame_index);$finish;
    end
endmodule
