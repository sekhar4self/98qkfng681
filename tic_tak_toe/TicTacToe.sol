pragma solidity ^0.4.19;
contract TicTacToe {
	uint[] matrix = new uint[](9);
	address player1;
	address player2;
	bool private player1_has_moved;
	bool private player2_has_moved;
	uint player_1_last_move;
	uint player_2_last_move;
    bool game_started = false;

	function TicTacToe() public{
		player1 = msg.sender;
	}

	function joinGame() public{
		player2 = msg.sender;
        game_started = true;
	}

	function makeMove(uint place) public returns (string){
        if (game_started == false) {
            return "Game not started";
        }
		uint winner = checkWinner();
		if(winner > 0){
			return "Game is already over";
		}
		if(place < 0 || place >= 9) {
			return "Please enter value in [0,8]";
		}
		if(msg.sender == player1) {
            if (player1_has_moved) {
                return "You have already placed the move";
            }
			player1_has_moved = true;
			if(player2_has_moved == true) {
				player1_has_moved = false;      //back to initial value for next moves
				player2_has_moved = false;

				//In case both players have made the same move, revert.
				if (place == player_2_last_move) {
					player_1_last_move = 100;       //back to initial value for next moves
					player_2_last_move = 100;
					return "Both players played same move. Reverting.";
				}

				//Update the matrix
				matrix[player_2_last_move] = 2;
				matrix[place] = 1;

				player_1_last_move = 100;       //back to initial value for next moves
				player_2_last_move = 100;
			} else {
				player_1_last_move = place;
			}
        } else if (msg.sender == player2) {
            if (player2_has_moved) {
                return "You have already placed the move";
            }
            player2_has_moved = true;
            if(player1_has_moved == true) {
                player1_has_moved = false;      //back to initial value for next moves
                player2_has_moved = false;

                //In case both players have made the same move, revert.
                if (place == player_1_last_move) {
                    player_1_last_move = 100;   //back to initial value for next moves
                    player_2_last_move = 100;
                    return "Both players played same move. Reverting.";
                }

                //Update the matrix
                matrix[player_1_last_move] = 2;
                matrix[place] = 1;

                player_1_last_move = 100;       //back to initial value for next moves
                player_2_last_move = 100;
            } else {
                player_2_last_move = place;
            }
		} else {
			return "You are not part of the game";
		}
		return "OK";
	}



	uint[][]  tests = [[0,1,2],[3,4,5],[6,7,8], [0,3,6],[1,4,7],[2,5,8], [0,4,8],[2,4,6]  ];
	// 0 1 2
	// 3 4 5
	// 6 7 8
	function checkWinner() public constant returns (uint){
		for(uint i = 0; i < 8;i++){
			uint[] memory b = tests[i];
			if(matrix[b[0]] != 0 && matrix[b[0]] == matrix[b[1]] && matrix[b[0]] == matrix[b[2]]) return matrix[b[0]];
		}
		return 0;
	}

	function current() public constant returns(string, uint256[3], uint256[3], uint256[3]) {
		string memory text = "No winner yet";
		uint winner = checkWinner();
		if(winner == 1){
			text = "Winner is 1";
		}
		if (winner == 2){
			text = "Winner is 2";
		}

		return (
			text,
			[matrix[0], matrix[1], matrix[2]],
			[matrix[3], matrix[4], matrix[5]],
			[matrix[6], matrix[7], matrix[8]]
		);
	}

}
