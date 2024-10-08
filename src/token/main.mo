import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";

actor Token {
    let owner : Principal = Principal.fromText("uy356-dzm46-miel6-z3hk5-hd2zo-5yupb-otqgc-xb5ct-lltgt-ha47g-2ae");
    let totalSupply : Nat = 1000000000;
    let symbol : Text = "ALVTT";

    private stable var balanceEntries: [(Principal, Nat)] = [];
    private var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);
    if (balances.size() < 1) {
            balances.put(owner, totalSupply);
    };
    

    public query func balanceOf(who: Principal) : async Nat {

        let balance : Nat = switch(balances.get(who)) {
            case null 0;
            case (?result) result;
        };

        return balance;
    };

    public query func getCurrency() : async Text {
        return symbol;
    };

    public shared(msg) func payOut() : async Text {
        // Debug.print(debug_show(msg.caller));
        if (balances.get(msg.caller) == null) {
            let amount = 10000;
            // balances.put(msg.caller, amount);
            let result = await transfer(msg.caller, amount);
            return result;
        } else {
            return "Allready claimed";
        }
    };

    public shared(msg) func transfer(to: Principal, amount: Nat) : async Text {
        let fromBalance = await balanceOf(msg.caller);
        if (fromBalance > amount) {
            let newFromBalance : Nat = fromBalance - amount;
            balances.put(msg.caller, newFromBalance);

            let toBalance = await balanceOf(to);
            let newToBalance = toBalance + amount;
            balances.put(to, newToBalance);

            return "Success";
        } else {
            return "Not enough tokens to transfer";
        }
    };

    system func preupgrade() {
        balanceEntries :=  Iter.toArray(balances.entries());
    };

    system func postupgrade() {
        balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash);
    
        if (balances.size() < 1) {
            balances.put(owner, totalSupply);
        }
    };

};