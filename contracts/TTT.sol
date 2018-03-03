pragma solidity ^0.4.19;
pragma experimental ABIEncoderV2;

import './DGame.sol';

contract TTT is DGame {
  uint32 private constant REASON_WRONG_LENGTH = 1;
  uint32 private constant REASON_NOT_A_SQUARE = 2;
  uint32 private constant REASON_ALREADY_PLAYED = 3;

  function TTT(address owner) DGame(owner) public {
  }

  function matchDuration() public pure returns (uint) {
    return 10 minutes;
  }

  function initialState(bytes, bytes) public pure returns (MetaState) {
    State memory state;

    state.data = new bytes(9);

    return meta(state);
  }

  function winnerImplementation(State state) internal pure returns (Winner) {
    if (byte(0) != state.data[0] && state.data[0] == state.data[1] && state.data[1] == state.data[2]) {
      return Winner(uint8(state.data[0]));

    } else if (byte(0) != state.data[3] && state.data[3] == state.data[4] && state.data[4] == state.data[5]) {
      return Winner(uint8(state.data[3]));

    } else if (byte(0) != state.data[6] && state.data[6] == state.data[7] && state.data[7] == state.data[8]) {
      return Winner(uint8(state.data[6]));

    } else if (byte(0) != state.data[0] && state.data[0] == state.data[3] && state.data[3] == state.data[6]) {
      return Winner(uint8(state.data[0]));

    } else if (byte(0) != state.data[1] && state.data[1] == state.data[4] && state.data[4] == state.data[7]) {
      return Winner(uint8(state.data[1]));

    } else if (byte(0) != state.data[2] && state.data[2] == state.data[5] && state.data[5] == state.data[8]) {
      return Winner(uint8(state.data[2]));

    } else if (byte(0) != state.data[0] && state.data[0] == state.data[4] && state.data[4] == state.data[8]) {
      return Winner(uint8(state.data[0]));

    } else if (byte(0) != state.data[2] && state.data[2] == state.data[4] && state.data[4] == state.data[6]) {
      return Winner(uint8(state.data[2]));

    } else {
      return Winner.NONE;
    }
  }

  function nextPlayersImplementation(State state) internal pure returns (NextPlayers) {
    if (state.tag >= 9) {
      return NextPlayers.NONE;
    }

    return NextPlayers(1 + state.tag % 2);
  }

  function isMoveLegalImplementation(State state, Move move) internal pure returns (bool, uint32) {
    if (move.data.length != 1) {
      return (false, REASON_WRONG_LENGTH);
    }

    if (move.data[0] >= 9) {
      return (false, REASON_NOT_A_SQUARE);
    }

    if (state.data[uint(move.data[0])] != 0) {
      return (false, REASON_ALREADY_PLAYED);
    }

    return (true, REASON_NONE);
  }

  function nextStateImplementation(State state, Move move) internal pure returns (MetaState) {
    State memory next;

    next.tag = state.tag + 1;
    next.data = new bytes(9);
    next.data[0] = state.data[0];
    next.data[1] = state.data[1];
    next.data[2] = state.data[2];
    next.data[3] = state.data[3];
    next.data[4] = state.data[4];
    next.data[5] = state.data[5];
    next.data[6] = state.data[6];
    next.data[7] = state.data[7];
    next.data[8] = state.data[8];
    next.data[uint(move.data[0])] = byte(1 + move.playerID);

    return meta(next);
  }
}
