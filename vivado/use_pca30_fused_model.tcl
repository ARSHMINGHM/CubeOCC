# Select only the 0.6201% grouped-CV PCA30-trained fused SVM branch.
set cubeocc_model_select 2
source [file join [file dirname [file normalize [info script]]] select_directional_model.tcl]
puts "Vivado will trim the disabled old_poly branch during synthesis."
