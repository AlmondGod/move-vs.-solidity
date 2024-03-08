pragma solidity ^0.8.0;

contract DebtManagement {
    struct KingdomData {
        uint debt;
        uint wood;
        uint coins;
        uint stone;
        uint taverns;
        uint bakeries;
        uint knights;
        uint lastCointime;
    }

    uint public constant COINS_PER_PERIOD = 10; 
    uint public constant PERIOD = 1 days; 

    mapping(address => KingdomData) public kingdoms;

    event Defeated(address _victor, address _loser);

    function addPlayer(address _player) public {
        kingdoms[_player] = KingdomData({
        debt: 0,
        wood: 0,
        coins: 0,
        stone: 0,
        taverns: 0,
        bakeries: 0,
        knights: 0,
        lastCointime: block.timestamp
    });
    }

    function borrow(address _player, uint _amount) public {
        kingdoms[_player].coins = _amount; 
        kingdoms[_player].debt += _amount;
    }

    function awardCoins(address _player) public {
        require(block.timestamp >= kingdoms[_player].lastCointime + PERIOD, "It's not time yet");
        kingdoms[_player].coins += COINS_PER_PERIOD * (9 * kingdoms[_player].bakeries + 4 * kingdoms[_player].taverns);
        kingdoms[_player].lastCointime = block.timestamp; 
    }

    function repayDebt(address _player, uint _amount) public {
        require(kingdoms[_player].coins >= _amount, "not enough coins to repay");
        kingdoms[_player].debt -= _amount;
        if (kingdoms[_player].debt < 0) {
            kingdoms[_player].debt = 0;
        }
    }

    function buildTavern(address _player, uint _amount) public {
        require(kingdoms[_player].coins >= 100 ** (kingdoms[_player].taverns), "not enough coins");
        kingdoms[_player].taverns += 1;
    }

    function buildBakery(address _player, uint _amount) public {
        require(kingdoms[_player].coins >= 255 ** (kingdoms[_player].bakeries), "not enough coins");
        kingdoms[_player].bakeries += 1;
    }

    function hireKnight(address _player, uint _amount) public {
        require(kingdoms[_player].coins >= 127 ** (kingdoms[_player].knights), "not enough coins");
        kingdoms[_player].knights += 1;
    }

    function attack(address _player, address _opponent) public {
        if(kingdoms[_player].knights < kingdoms[_opponent].knights) {
            kingdoms[_player].debt += kingdoms[_opponent].debt + (1000 * (kingdoms[_opponent].knights - kingdoms[_player].knights));
            kingdoms[_player].knights = 0;
            kingdoms[_player].taverns /= 2;
            kingdoms[_player].bakeries = 0;
            emit Defeated(_opponent, _player);
        }
        else {
            kingdoms[_opponent].debt += kingdoms[_player].debt + (1000 * (kingdoms[_player].knights - kingdoms[_opponent].knights));
            kingdoms[_opponent].knights = 0;
            kingdoms[_opponent].taverns /= 2;
            kingdoms[_opponent].bakeries = 0;
            emit Defeated(_player, _opponent);
        }
    }

    
}
