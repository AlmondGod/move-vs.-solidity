address 0x1 {
module GameCharacter {
    struct Character {
        name: vector<u8>,
        health: u64,
    }
    
    public fun create_character(name: vector<u8>, health: u64): Character {
        Character { name, health }
    }
    
    public fun take_damage(character: &mut Character, amount: u64) {
        if (character.health < amount) {
            character.health = 0;
        } else {
            character.health -= amount;
        }
    }
    
    public fun heal(character: &mut Character, amount: u64) {
        character.health += amount;
    }
}

module Warrior {
    use 0x1::GameCharacter;
    
    struct Warrior {
        character: GameCharacter::Character,
        armor: u64,
    }
    
    public fun create_warrior(name: vector<u8>, health: u64, armor: u64): Warrior {
        let character = GameCharacter::create_character(name, health);
        Warrior { character, armor }
    }
    
    public fun take_damage(warrior: &mut Warrior, amount: u64) {
        let effective_damage = if (amount > warrior.armor) amount - warrior.armor else 0;
        GameCharacter::take_damage(&mut warrior.character, effective_damage);
    }
}
}