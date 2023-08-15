////////////////////////
/// License         ///
//////////////////////
// SPDX-License-Identifier: MIT

////////////////////////////////////
/// Compiler Version            ///
//////////////////////////////////
pragma solidity ^0.8.18;

////////////////////////////////////////
/// Nat-Spec Documentation          ///
//////////////////////////////////////
/**
 * @title SimpleStorage
 * @author theirrationalone
 * @dev SimpleStorage for Storing user's Favorite Number
 * @notice This contract Asks user to Enter his/her Favorite Number and do store that number into its bytecode.
 */

////////////////////////////
/// Contract            ///
//////////////////////////
contract SimpleStorage {
    ////////////////////////
    /// Errors          ///
    //////////////////////
    error SimpleStorage__MustBeGreaterThanZero();
    error SimpleStorage__NameCannotBeEmpty();
    error SimpleStorage__InvalidOrNotAllowedCall();

    ////////////////////////////////////////////
    /// Directives and custom types         ///
    //////////////////////////////////////////
    struct Person {
        uint256 favoriteNumber;
        string name;
    }

    ////////////////////////////////
    /// State variables         ///
    //////////////////////////////
    uint256 private s_favoriteNumber;

    Person[] private s_people;
    mapping(string name => uint256 favoriteNumber) private s_personFavoriteNumber;

    ////////////////////////////////////
    /// Special Functions           ///
    //////////////////////////////////
    /**
     * @dev Doesn't allow any low level Function call without calldata.
     */

    receive() external payable {
        revert SimpleStorage__InvalidOrNotAllowedCall();
    }

    /**
     * @dev Doesn't allow any low level Function call even with calldata.
     * @notice If there's any function present inside "fallback" function(special) as a fallback,
     *
     *     And on very same invocation, If any other function's signature passed into "call" funtion as an argument or lets say if any "Invalid" data passed into "call" function as an argument,
     *
     *     And the Contract (on which "call" function invoked) hasn't that other function(whose signature is passed into call function)...
     *
     *     Then, that function who was already inside the "fallback" function shall be executed.
     *
     *     And If function signature is valid and its definition is in the contract (on which "call" function invoked) then it will be executed and the function who's inside the "fallback" function shall be ignored.
     *
     *     As the name itself suggests "fallback" statements inside it, will be executed at last and "call" function will return True Boolean and data(if had) otherwise (in all other above cases where signature is valid) will return False Boolean and data(if had).
     *
     * The fact here is, Even if "call" function returns False Boolean, It will execute or invoke "signatured" function if that's a valid function available into the Contract on which "call" function was performed.
     *
     *
     * @notice Keep everything in mind from previous @notice.... and read below comments...
     *
     * @notice If we Pass some balance or more concise some(valid balance) with "call" funciton like this: **address.call{value: 1 ether}("some_data")** and "call" function has a valid signature of a function that also exists into the referenced contract then...
     *
     *
     * The "call" function will return false and won't execute any statement inside "fallback" function.
     * Actually the reason behind getting False boolean in this use-case is that...
     * A Contract can't pay to itself and also expects a payable function either in "fallback" function or in "signatured" function(if valid & available). Also applicable on "receive" function but with empty data only.
     *
     *
     * So the conclusion is... That's ***THE REASON*** why we need to have either an owner(immutable variable) or onlyOwner Modifier.
     *
     */

    fallback() external payable {
        // addPerson("any", 12);
        revert SimpleStorage__InvalidOrNotAllowedCall();
    }

    /////////////////////////////////////////////
    /// External & Public Functions          ///
    ///////////////////////////////////////////
    /**
     * @param _favoriteNumber Person's favorite-Number.
     * @dev Stores Person's Favorite-Number into Contract's storage.
     * @notice In future, If Any contract inherits this contract then that can override this Function.
     */
    function storeNumber(uint256 _favoriteNumber) public virtual {
        if (_favoriteNumber <= 0) {
            revert SimpleStorage__MustBeGreaterThanZero();
        }

        s_favoriteNumber = _favoriteNumber;
    }

    /**
     * @param _name Person's name to keep their records trackable.
     * @param _favoriteNumber Person's Favorite-Number to Map with thier names.
     * @dev It makes a list of Person's Favorite-Number mapped with their names.
     */
    function addPerson(string calldata _name, uint256 _favoriteNumber) public {
        if (keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked(""))) {
            revert SimpleStorage__NameCannotBeEmpty();
        }

        if (_favoriteNumber <= 0) {
            revert SimpleStorage__MustBeGreaterThanZero();
        }

        s_people.push(Person({name: _name, favoriteNumber: _favoriteNumber}));
        s_personFavoriteNumber[_name] = _favoriteNumber;
    }

    ////////////////////////////////////////////////
    /// Veiw & Pure Helper Functions            ///
    //////////////////////////////////////////////
    function getFavoriteNumber() external view returns (uint256) {
        return s_favoriteNumber;
    }

    function getPersonDetailFromList(uint256 _personIndex) external view returns (Person memory) {
        return s_people[_personIndex];
    }

    function getPersonFavoriteNumber(string calldata _personName) external view returns (uint256) {
        return s_personFavoriteNumber[_personName];
    }
}
