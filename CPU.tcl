
################################################################
# This is a generated script based on design: CPU
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2025.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source CPU_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# InstructionMemory, program_counter, instr_reg, instr_decoder, Register_file, alu, multiplier, exec_mux, data_memory, wb_mux, controller, more_mux

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7s50csga324-1
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name CPU

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
InstructionMemory\
program_counter\
instr_reg\
instr_decoder\
Register_file\
alu\
multiplier\
exec_mux\
data_memory\
wb_mux\
controller\
more_mux\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set Z_0 [ create_bd_port -dir O Z_0 ]
  set G_0 [ create_bd_port -dir O G_0 ]
  set L_0 [ create_bd_port -dir O L_0 ]
  set clk_0 [ create_bd_port -dir I -type clk clk_0 ]
  set reg_val_0 [ create_bd_port -dir O -from 7 -to 0 reg_val_0 ]
  set reg_no_0 [ create_bd_port -dir I -from 2 -to 0 reg_no_0 ]
  set rst_0 [ create_bd_port -dir I -type rst rst_0 ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $rst_0

  # Create instance: InstructionMemory_0, and set properties
  set block_name InstructionMemory
  set block_cell_name InstructionMemory_0
  if { [catch {set InstructionMemory_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $InstructionMemory_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: program_counter_0, and set properties
  set block_name program_counter
  set block_cell_name program_counter_0
  if { [catch {set program_counter_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $program_counter_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: instr_reg_0, and set properties
  set block_name instr_reg
  set block_cell_name instr_reg_0
  if { [catch {set instr_reg_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $instr_reg_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: instr_decoder_0, and set properties
  set block_name instr_decoder
  set block_cell_name instr_decoder_0
  if { [catch {set instr_decoder_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $instr_decoder_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: Register_file_0, and set properties
  set block_name Register_file
  set block_cell_name Register_file_0
  if { [catch {set Register_file_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Register_file_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: alu_0, and set properties
  set block_name alu
  set block_cell_name alu_0
  if { [catch {set alu_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $alu_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: multiplier_0, and set properties
  set block_name multiplier
  set block_cell_name multiplier_0
  if { [catch {set multiplier_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $multiplier_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: exec_mux_0, and set properties
  set block_name exec_mux
  set block_cell_name exec_mux_0
  if { [catch {set exec_mux_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $exec_mux_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: data_memory_0, and set properties
  set block_name data_memory
  set block_cell_name data_memory_0
  if { [catch {set data_memory_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $data_memory_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: wb_mux_0, and set properties
  set block_name wb_mux
  set block_cell_name wb_mux_0
  if { [catch {set wb_mux_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $wb_mux_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: controller_0, and set properties
  set block_name controller
  set block_cell_name controller_0
  if { [catch {set controller_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $controller_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: more_mux_0, and set properties
  set block_name more_mux
  set block_cell_name more_mux_0
  if { [catch {set more_mux_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $more_mux_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create port connections
  connect_bd_net -net InstructionMemory_0_instr  [get_bd_pins InstructionMemory_0/instr] \
  [get_bd_pins instr_reg_0/ir_in]
  connect_bd_net -net Register_file_0_read_data1  [get_bd_pins Register_file_0/read_data1] \
  [get_bd_pins multiplier_0/a] \
  [get_bd_pins exec_mux_0/rs1_data] \
  [get_bd_pins alu_0/A]
  connect_bd_net -net Register_file_0_read_data2  [get_bd_pins Register_file_0/read_data2] \
  [get_bd_pins multiplier_0/b] \
  [get_bd_pins alu_0/B]
  connect_bd_net -net Register_file_0_reg_val  [get_bd_pins Register_file_0/reg_val] \
  [get_bd_ports reg_val_0]
  connect_bd_net -net alu_0_G  [get_bd_pins alu_0/G] \
  [get_bd_ports G_0]
  connect_bd_net -net alu_0_L  [get_bd_pins alu_0/L] \
  [get_bd_ports L_0]
  connect_bd_net -net alu_0_Result  [get_bd_pins alu_0/Result] \
  [get_bd_pins exec_mux_0/alu_result]
  connect_bd_net -net alu_0_Z  [get_bd_pins alu_0/Z] \
  [get_bd_ports Z_0]
  connect_bd_net -net clk_0_1  [get_bd_ports clk_0] \
  [get_bd_pins program_counter_0/clk] \
  [get_bd_pins instr_reg_0/clk] \
  [get_bd_pins data_memory_0/clk] \
  [get_bd_pins Register_file_0/clk] \
  [get_bd_pins controller_0/clk]
  connect_bd_net -net controller_0_alu_op  [get_bd_pins controller_0/alu_op] \
  [get_bd_pins alu_0/ALUOp]
  connect_bd_net -net controller_0_exec_mux  [get_bd_pins controller_0/exec_mux] \
  [get_bd_pins exec_mux_0/sel]
  connect_bd_net -net controller_0_halt_en  [get_bd_pins controller_0/halt_en] \
  [get_bd_pins program_counter_0/halt_en]
  connect_bd_net -net controller_0_ir_write  [get_bd_pins controller_0/ir_write] \
  [get_bd_pins instr_reg_0/ir_write]
  connect_bd_net -net controller_0_mem_read  [get_bd_pins controller_0/mem_read] \
  [get_bd_pins data_memory_0/mem_read]
  connect_bd_net -net controller_0_mem_write  [get_bd_pins controller_0/mem_write] \
  [get_bd_pins data_memory_0/mem_write]
  connect_bd_net -net controller_0_phase_out  [get_bd_pins controller_0/phase_out] \
  [get_bd_pins more_mux_0/oper]
  connect_bd_net -net controller_0_reg_re  [get_bd_pins controller_0/reg_re] \
  [get_bd_pins Register_file_0/re]
  connect_bd_net -net controller_0_reg_we  [get_bd_pins controller_0/reg_we] \
  [get_bd_pins Register_file_0/we]
  connect_bd_net -net controller_0_wb_mux  [get_bd_pins controller_0/wb_mux] \
  [get_bd_pins wb_mux_0/sel]
  connect_bd_net -net data_memory_0_read_data  [get_bd_pins data_memory_0/read_data] \
  [get_bd_pins wb_mux_0/mem_data]
  connect_bd_net -net exec_mux_0_out  [get_bd_pins exec_mux_0/out] \
  [get_bd_pins data_memory_0/write_data] \
  [get_bd_pins wb_mux_0/exec_result]
  connect_bd_net -net instr_decoder_0_mem_addr  [get_bd_pins instr_decoder_0/mem_addr] \
  [get_bd_pins data_memory_0/address]
  connect_bd_net -net instr_decoder_0_opcode  [get_bd_pins instr_decoder_0/opcode] \
  [get_bd_pins controller_0/opcode]
  connect_bd_net -net instr_decoder_0_r3  [get_bd_pins instr_decoder_0/r3] \
  [get_bd_pins more_mux_0/r3]
  connect_bd_net -net instr_decoder_0_rd  [get_bd_pins instr_decoder_0/rd] \
  [get_bd_pins Register_file_0/write_reg] \
  [get_bd_pins more_mux_0/r4]
  connect_bd_net -net instr_decoder_0_rs1  [get_bd_pins instr_decoder_0/rs1] \
  [get_bd_pins more_mux_0/r1]
  connect_bd_net -net instr_decoder_0_rs2  [get_bd_pins instr_decoder_0/rs2] \
  [get_bd_pins more_mux_0/r2]
  connect_bd_net -net instr_reg_0_ir_out  [get_bd_pins instr_reg_0/ir_out] \
  [get_bd_pins instr_decoder_0/instr]
  connect_bd_net -net more_mux_0_rout1  [get_bd_pins more_mux_0/rout1] \
  [get_bd_pins Register_file_0/read_reg1]
  connect_bd_net -net more_mux_0_rout2  [get_bd_pins more_mux_0/rout2] \
  [get_bd_pins Register_file_0/read_reg2]
  connect_bd_net -net multiplier_0_product_out  [get_bd_pins multiplier_0/product_out] \
  [get_bd_pins exec_mux_0/mul_result]
  connect_bd_net -net program_counter_0_pc_out  [get_bd_pins program_counter_0/pc_out] \
  [get_bd_pins InstructionMemory_0/pc]
  connect_bd_net -net reg_no_0_1  [get_bd_ports reg_no_0] \
  [get_bd_pins Register_file_0/reg_no]
  connect_bd_net -net rst_0_1  [get_bd_ports rst_0] \
  [get_bd_pins program_counter_0/rst] \
  [get_bd_pins instr_reg_0/rst] \
  [get_bd_pins controller_0/rst]
  connect_bd_net -net wb_mux_0_wb_data  [get_bd_pins wb_mux_0/wb_data] \
  [get_bd_pins Register_file_0/write_data]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


