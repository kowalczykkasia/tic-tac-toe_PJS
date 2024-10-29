board=()

player1="X"
player2="O"
current_player=$player1
playing_with_computer=${1:-false}

clear_board(){
	board=("-" "-" "-" "-" "-" "-" "-" "-" "-")
}

read_board() {
	read -a board < board.txt	
}

save_board() {
	printf "%s " "${board[@]}" > board.txt
        echo "Successfully saved!"
        exit
}

init_board() {
	echo ""	
    echo " ${board[0]}  |  ${board[1]}  |  ${board[2]}"
    echo "--- | --- | ---"
    echo " ${board[3]}  |  ${board[4]}  |  ${board[5]}"
    echo "--- | --- | ---"
    echo " ${board[6]}  |  ${board[7]}  |  ${board[8]}"
}

greet_winer(){
	player_name=$1
	echo "$player_name ($current_player)  won!"
	rm -f board.txt
	exit
}

is_draw() {
	for row in "${board[@]}"; do
		if [[ "$row" == *"-"* ]]; then
            		return 1
        	fi
    	done
	return 0

}

check_win(){
	n=3
	player_name=$2
	for ((i=0; i<n; i++)); do
		if [[ ${board[$((i*n))]} == $current_player && ${board[$((i*n+1))]} == $current_player && ${board[$((i*n+2))]} == $current_player ]]; then
			greet_winer $player_name
		fi

		if [[ ${board[$((i))]} == $current_player && ${board[$((i+n))]} == $current_player && ${board[$((i+n*2))]} == $current_player ]]; then
                        greet_winer $player_name  
                fi
	done

	if [[ ${board[$((0))]} == $current_player && ${board[$((4))]} == $current_player && ${board[$((8))]} == $current_player ]]; then
       		greet_winer $player_name  
       	fi

        if [[ ${board[$((2))]} == $current_player && ${board[$((4))]} == $current_player && ${board[$((6))]} == $current_player ]]; then
                greet_winer $player_name  
        fi
}


init_move() {
	player_name=""
	if [[ $current_player == "X" ]]; then
		player_name="Player 1"
	else
		player_name="Player 2"
	fi

        echo "$player_name , please enter your move (1-9):"
        
	read_input $player_name
}


read_input(){
	player_name=$2

	if [[ $current_player == $player2 && "$playing_with_computer" == true ]]; then
                move=$(get_random_value)
        else
                read -r move
        fi 

	if [[ $move == "save" ]]; then
		save_board
	elif [[ $move == "clear" ]]; then
		clear_board
	elif [[ $move == "0" ]]; then
		exit
        elif [[ ${board[$move-1]} == "X" || ${board[$move-1]} == "O" ]]; then
                echo "Invalid move, try again."
		read_input $player_name
        else                     
		echo $move
                board[$move-1]=$current_player
                init_board
		if is_draw; then
			echo "Oh no! Today nobody wins. Try again!"
			clear_board
			init_board
		else

			check_win $player_name
		fi
        fi
}

start() {
	if [[ -f "board.txt" ]]; then
        	echo "Do you want to continue saved game? Y / N"
        	read -r continue_with_saved
        	if [[ $continue_with_saved == "Y" || $continue_with_saved == "y" ]]; then
        	        read_board
        	else
                	clear_board
			rm -f board.txt
       		fi
	else
        	board=("-" "-" "-" "-" "-" "-" "-" "-" "-")
	fi	
}

check_who_starts() {
	count_X=0
	count_O=0
	for cell in "${board[@]}"; do
	    	if [[ $cell == "X" ]]; then
        		((count_X++))
    		elif [[ $cell == "O" ]]; then
        		((count_O++))
    		fi
	done

	if [[ "$count_X" -gt "$count_O" ]]; then
		current_player=$player2
	else	
		current_player=$player1
	fi 	
}

get_random_value() {
	echo $(( (RANDOM % 9) + 1 ))
}





#Start of program

start

check_who_starts

init_board

while true; do
       	
	init_move
	
	if [[ $current_player == $player1  ]]; then
		current_player=$player2
	else
		current_player=$player1
	fi


done

