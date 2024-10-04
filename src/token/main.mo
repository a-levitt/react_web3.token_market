import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";

actor Token {
    var owner : Principal = Principal.fromText("uy356-dzm46-miel6-z3hk5-hd2zo-5yupb-otqgc-xb5ct-lltgt-ha47g-2ae");
    var totalSupply : Nat = 1000000000;
    var symbol : Text = "ALVTT";

    var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);
    
};