set project_name "keras_mnist_npu_fpga"
set project_dir "./vivado_project"
set part "xc7vx485tffg1157-1"

create_project $project_name $project_dir -part $part -force
set_property target_language Verilog [current_project]

add_files [glob -nocomplain ./rtl/*.v]
add_files -fileset sim_1 [glob -nocomplain ./tb/*.v]

set_property top mnist_npu_top [get_filesets sources_1]
set_property top mnist_npu_tb [get_filesets sim_1]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
puts "Project created. Synthesis top: mnist_npu_top"
puts "Simulation top: mnist_npu_tb"
