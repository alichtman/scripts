# http://mewbies.com/acute_terminal_fun_02_view_ascii_art_ansi_art_and_movies_on_the_terminal.htm
# Written by Charles Cooke
# Requires bash. Not zsh compatible.

for((P=10**8,Q=P/100,X=320*Q/(`tput cols`-1),Y=210*Q/`tput lines`,y=-105*Q,v=-220*Q,x=v;y<105*Q;x=v,y+=Y));do
    for((;x<P;a=b=i=k=c=0,x+=X));do
        for((;a*a+b*b<2*P*P&&i++<99;a=((c=a)*a-b*b)/P+x,b=2*c*b/P+y));do
            :;
        done;
        (((j=(i<99?i%16:0)+30)>37?k=1,j-=8:0));
        echo -ne "\E[$k;$j"mE;
    done;
    echo -e "\E[0m";
done
