pragma solidity ^0.8.0;

contract DebtManagement {
    struct KingdomData {
        uint debt;
        uint wood;
        uint coins;
        uint stone;
        uint taverns;
        uint brothels;
        uint knights;
    }

    mapping(address => KingdomData) public kingdoms;

    event Defeated(address _victor, address _loser);

    function addPlayer(address _player) public {
        kingdoms[_player] = new KingdomData(0, 0, 0, 0, 0, 0);
    }

    function borrow(address _player, int _amount) public {
        kingdoms[_player].coins += _amount; 
        kingdoms[_player].coins += _amount;
    }

    function repayDebt(address _player, int _amount) public {
        require(kingdoms[_player].coins >= _amount, "not enough coins to repay");
        kingdoms[_player].debt -= _amount;
        if (kingdoms[_player].debt < 0) {
            kingdoms[_player].debt = 0;
        }
    }

    function buildTavern(address _player, int _amount) public {
        require(kingdoms[_player].coins >= 100 ** (kingdoms[_player].tavern), "not enough coins");
        kingdoms[_player].taverns += 1;
    }

    function buildBrothel(address _player, int _amount) public {
        require(kingdoms[_player].coins >= 255 ** (kingdoms[_player].brothel), "not enough coins");
        kingdoms[_player].brothels += 1;
    }

    function hireKnight(address _player, int _amount) public {
        require(kingdoms[_player].coins >= 127 ** (kingdoms[_player].knights), "not enough coins");
        kingdoms[_player].knights += 1;
    }

    function attack(address _player, address _opponent) public {
        if(kingdoms[_player].knights < kingdoms[_opponent].knights) {
            kingdoms[_player].debt += kingdoms[_opponent].debt + (1000 * (kingdoms[_opponent].knights - kingdoms[_player].knights));
            kingdoms[_player].knights = 0;
            kingdoms[_player].taverns /= 2;
            kingdoms[_player].brothels = 0;
            emit Defeated(_opponent, _player);
        }
        else {
            kingdoms[_opponent].debt += kingdoms[_player].debt + (1000 * (kingdoms[_player].knights - kingdoms[_opponent].knights));
            kingdoms[_opponent].knights = 0;
            kingdoms[_opponent].taverns /= 2;
            kingdoms[_opponent].brothels = 0;
            emit Defeated(_player, _opponent);
        }
    }

    
}
