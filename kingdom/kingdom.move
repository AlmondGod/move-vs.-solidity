
address 0x1 {
module KingdomManagement {
    use std::u64;

    struct KingdomData has key, store {
        wood: u64,
        coins: u64,
        stone: u64,
        taverns: u64,
        brothels: u64,
        knights: u64,
        debt: u64,
    }

    struct DefeatedEvent has drop, store {
        victor: address,
        loser: address,
    }

    public fun add_player(player: address) {
        let kingdom_data = KingdomData {
            wood: 0,
            coins: 0,
            stone: 0,
            taverns: 0,
            brothels: 0,
            knights: 0,
            debt: 0,
        };
        move_to(player, kingdom_data);
    }

    public fun borrow(player: address, amount: u64) acquires KingdomData {
        let kingdom_ref = borrow_global_mut<KingdomData>(player);
        kingdom_ref.debt = kingdom_ref.debt + amount;
        assert!(kingdom_ref.debt >= amount, 1); 
    }

    spec borrow(player: address, amount: u64) acquires KingdomData {
        let kingdom_ref = borrow_global_mut<KingdomData>(player);
        aborts_if kingdom_ref.debt + amount > MAX_U64;
        requires kingdom_ref.debt + amount <= MAX_U64;
    }

    public fun attack(attacker: &signer, defender_addr: address) acquires KingdomData {
        let attacker_addr = Signer::address_of(attacker);
        let attacker_data = borrow_global_mut<KingdomData>(attacker_addr);
        let defender_data = borrow_global_mut<KingdomData>(defender_addr);

        if (attacker_data.knights < defender_data.knights) {
            let debt_increase = defender_data.debt + (1000 * (defender_data.knights - attacker_data.knights));
            attacker_data.debt += debt_increase;
            attacker_data.knights = 0;
            attacker_data.taverns = attacker_data.taverns / 2;
            attacker_data.brothels = 0;
            emit_defeated_event(defender_addr, attacker_addr);
        } else {
            let debt_increase = attacker_data.debt + (1000 * (attacker_data.knights - defender_data.knights));
            defender_data.debt += debt_increase;
            defender_data.knights = 0;
            defender_data.taverns = defender_data.taverns / 2;
            defender_data.brothels = 0;
            emit_defeated_event(attacker_addr, defender_addr);
        }
    }

    spec attack(attacker: &signer, defender_addr: address) acquires KingdomData {
        let attacker_addr = Signer::address_of(attacker);
        let attacker_data = borrow_global_mut<KingdomData>(attacker_addr);
        let defender_data = borrow_global_mut<KingdomData>(defender_addr);

        if (attacker_data.knights < defender_data.knights) {
            let debt_increase = defender_data.debt + (1000 * (defender_data.knights - attacker_data.knights));
            aborts_if attacker_data.debt + debt_increase > MAX_U64;
            requires attacker_data.debt + debt_increase <= MAX_U64;
        } else {
            let debt_increase = attacker_data.debt + (1000 * (attacker_data.knights - defender_data.knights));
            aborts_if defender_data.debt + debt_increase > MAX_U64;
            requires defender_data.debt + debt_increase <= MAX_U64;
        }

    }

    public fun buildTavern(player: address) acquires KingdomData {
        let kingdom_ref = borrow_global_mut<KingdomData>(player);
        assert!(kingdom_ref.coins >= 100 ** kingdom_ref.taverns, 1); 
        kingdom_ref.taverns = kingdom_ref.taverns + 1;
        kingdom_ref.coins -= 100 ** kingdom_ref.taverns;
    }

    spec borrow(player: address, amount: u64) acquires KingdomData {
        let kingdom_ref = borrow_global_mut<KingdomData>(player);
        aborts_if 100 ** kingdom_ref.taverns > MAX_U64;
        requires 100 ** kingdom_ref.taverns <= MAX_U64;
    }

    public fun buildBrothel(player: address) acquires KingdomData {
        let kingdom_ref = borrow_global_mut<KingdomData>(player);
        assert!(kingdom_ref.coins >= 255 ** kingdom_ref.brothels, 1); 
        kingdom_ref.brothels= kingdom_ref.brothels + 1;
        kingdom_ref.coins -= 255 ** kingdom_ref.brothels;
    }

    spec borrow(player: address, amount: u64) acquires KingdomData {
        let kingdom_ref = borrow_global_mut<KingdomData>(player);
        aborts_if 255 ** kingdom_ref.brothels > MAX_U64;
        requires 255 ** kingdom_ref.brothels <= MAX_U64;
    }

    public fun hireKnight(player: address) acquires KingdomData {
        let kingdom_ref = borrow_global_mut<KingdomData>(player);
        assert!(kingdom_ref.coins >= 127 ** kingdom_ref.knights, 1); 
        kingdom_ref.knights = kingdom_ref.knights + 1;
        kingdom_ref.coins -= 127 ** kingdom_ref.knights;
    }

    spec borrow(player: address, amount: u64) acquires KingdomData {
        let kingdom_ref = borrow_global_mut<KingdomData>(player);
        aborts_if 127 ** kingdom_ref.knights > MAX_U64;
        requires 127 ** kingdom_ref.knights <= MAX_U64;
    }
}
}
