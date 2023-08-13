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
     */
    fallback() external payable {
        revert SimpleStorage__InvalidOrNotAllowedCall();
    }

    /////////////////////////////////////////////
    /// External & Public Functions          ///
    ///////////////////////////////////////////
    /**
     * @param _favoriteNumber Person's favorite-Number.
     * @dev Stores Person's Favorite-Number into Contract's storage.
     *
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
