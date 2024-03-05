pragma solidity ^0.8.0;

contract GameCharacter {
    string public name;
    uint public health;
    
    constructor(string memory _name) {
        name = _name;
        health = 100;
    }
    
    function takeDamage(uint amount) public {
        if (health < amount) {
            health = 0;
        } else {
            health -= amount;
        }
    }
    
    function heal(uint amount) public {
        health += amount;
    }
}

contract Warrior is GameCharacter {
    uint public armor;
    
    constructor(string memory _name, uint _armor) GameCharacter(_name) {
        armor = _armor;
    }
    
    function takeDamage(uint amount) public override {
        uint effectiveDamage = amount > armor ? amount - armor : 0;
        super.takeDamage(effectiveDamage);
    }
}
