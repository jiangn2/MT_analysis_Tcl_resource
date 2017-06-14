#File: Curvature
#Author: Nan Jiang
#Created: 06/14/2017
#Function: Calculate the radius of curvature of 3 dimers in MT

proc curvature {seltext1 seltext2 seltext3} {

        set lnum1 [expr ($seltext1 - 1) * 866]
        set rnum1 [expr $seltext1 * 866 - 1]
        set sel1 [atomselect top "(index $lnum1 to $rnum1)"]


        set lnum2 [expr ($seltext2 - 1) * 866]
        set rnum2 [expr $seltext2 * 866 - 1]
        set sel2 [atomselect top "(index $lnum2 to $rnum2)"]


        set lnum3 [expr ($seltext3 - 1) * 866]
        set rnum3 [expr $seltext3 * 866 - 1]
        set sel3 [atomselect top "(index $lnum3 to $rnum3)"]


        set nf [molinfo top get numframes]
##################################################
# Loop over all frames.                          #
##################################################
        set outfile [open curvature_new7.dat w]
        for {set i 2} {$i < $nf} {incr i} {
        
                puts "frame $i of $nf"

                $sel1 frame $i
                $sel3 frame $i
                $sel2 frame $i
        
        
                set com1 [measure center $sel1 weight mass]
                set com3 [measure center $sel3 weight mass]
                set com2 [measure center $sel2 weight mass]



                set yy1 [lindex $com1 1]
                set yy2 [lindex $com2 1]
                set yy3 [lindex $com3 1]

                set diff [expr ($yy2 * 2 - $yy1 -$yy3)]

        
                draw color [expr $i % 33]
                draw line $com1 $com2 width 5 style solid 
                draw line $com2 $com3 width 5 style solid
                draw line $com1 $com3 width 5 style solid
        
                set simdata1($i.r) [veclength [vecsub $com1 $com2]]
                set simdata2($i.r) [veclength [vecsub $com2 $com3]]
                set simdata3($i.r) [veclength [vecsub $com1 $com3]]
        
                set rd [expr $simdata1($i.r) * $simdata2($i.r) * $simdata3($i.r)/sqrt(($simdata1($i.r)+$simdata2($i.r)+$simdata3($i.r))*($simdata1($i.r)+$simdata2($i.r)-$simdata3($i.r))*($simdata1($i.r)-$simdata2($i.r)+$simdata3($i.r))*(-$simdata1($i.r)+$simdata2($i.r)+$simdata3($i.r)))]
        
                set v1 [vecsub $com1 $com2]
                set v2 [vecsub $com2 $com3]
                set cos [expr [vecdot $v1 $v2]/([veclength $v1]*[veclength $v2])]
                set angle [expr acos($cos) * 180 / 3.141593]
        
                if {$diff < 0} {set angle [expr (-$angle)]}
                puts $outfile "$i   $rd   $cos   $angle"
        
        }
        close $outfile
}
