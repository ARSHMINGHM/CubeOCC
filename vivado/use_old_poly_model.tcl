# Select only the 0.7181% grouped-CV directional degree-2 SVM branch.
set cubeocc_model_select 1
source [file join [file dirname [file normalize [info script]]] select_directional_model.tcl]
puts "Vivado will trim the disabled pca30_fused branch during synthesis."
