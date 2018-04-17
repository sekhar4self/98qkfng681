pragma solidity ^0.4.19;
contract TicTacToe {
	uint[] board = new uint[](9);
	address player1;
	address player2;
	bool private player1_has_moved;
	bool private player2_has_moved;
	uint player_1_last_move;
	uint player_2_last_move;

	constructor() public{
		player1 = msg.sender;
	}

	function joinGame() public{
		player2 = msg.sender;
	}

	function makeMove(uint place) public returns (string){
		uint winner = checkWinner();
		if(winner > 0){
			return "Game is already over";
		}
		if(place < 0 || place >= 9) {
			return "Please enter value in [0,8]";
		}
		if(msg.sender == player1) {
			player1_has_moved = true;
			if(player2_has_moved == true) {
				player1_has_moved = false;
				player2_has_moved = false;
				if (place == player_2_last_move) {
					return "Both players played same move. Reverting.";
				}
				player_1_last_move = 100; //back to initial value
				player_2_last_move = 100;
			} else {
				player_1_last_move = place;
			}
		} else if (msg.sender == player2) {
			player2_has_moved = true;
			if(player1_has_moved == true) {
				player1_has_moved = false;
				player2_has_moved = false;
				if (place == player_1_last_move) {
					return "Both players played same move. Reverting.";
				}
				player_1_last_move = 100; //back to initial value
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
		for(uint i =0; i < 8;i++){
			uint[] memory b = tests[i];
			if(board[b[0]] != 0 && board[b[0]] == board[b[1]] && board[b[0]] == board[b[2]]) return board[b[0]];
		}


		return 0;
	}

	function current() public constant returns(string, string) {
		string memory text = "No winner yet";
		uint winner = checkWinner();
		if(winner == 1){
			text = "Winner is X";
		}
		if (winner == 2){
			text = "Winner is O";
		}


		//bytes memory out = new bytes(11);
		byte[] memory signs = new byte[](3);
		signs[0] = "-";
		signs[1] = "X";
		signs[2] = "O";
		//bytes(out)[3] = "|";
		//bytes(out)[7] = "|";

		for(uint i =0; i < 9;i++){
			//  bytes(out)[i + i/3] = signs[board[i]];

		}

		return (text, "string(out)");
	}

}
