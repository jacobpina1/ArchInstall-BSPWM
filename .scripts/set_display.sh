#Get current output name
monitor=$(xrandr | grep " connected " | awk '{ print$1 }')

#Get monitors maximum resolution
resolution=$(xrandr | grep " connected" | awk '{ print $3 }' | awk -F'[+]>

xrandr --output $monitor --mode $resolution --rate 165
