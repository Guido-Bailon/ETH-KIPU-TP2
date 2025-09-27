// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.2;

contract KipuBank{
    /*///////////////////////
					Variables
	///////////////////////*/
    ///@notice constante que indica el maximo valor almacenable de eth para cada usuario
    uint256 constant MAX_VAULT = 10000;
    ///@notice variable inmutable que indica la maxima cantidad de eth que pueden retirarse en una unica transaccion
    uint256 immutable i_maxWithdrawal;
    ///@notice variable utilizada para almacenar la boveda de cada usuario
    mapping(address user => uint256 vault) private s_vaults;
    ///@notice variable que almacena la cantidad total de depositos
    uint256 private s_deposits;
    ///@notice variable que almacena la cantidad total de retiros
    uint256 private s_withdrawals;

    
    /*///////////////////////
					Events
	///////////////////////*/
    ///@notice evento emitido cuando un usuario realiza un deposito correctamente
    event KipuBank_deposit(address user, uint256 value);
    ///@notice evento emitido cuando un usuario realiza un retiro correctamente
    event KipuBank_withdrawal(address user, uint256 value);
    
    /*///////////////////////
					Errors
	///////////////////////*/
    ///@notice error emitido cuando un usuario quiere depositar y fuera a superar el maximo de su boveda
    error KipuBank_bankCapped(address caller);
    ///@notice error emitido cuando un usuario quiere retirar mas fondos de los que posee en su boveda
    error KipuBank_unsuficentFunds(address caller);
    ///@notice error emitido cuando un usuario quiere retirar mas fondos de lo permitido por el banco
    error KipuBank_withdrawalCapped(address caller);
    ///@notice error emitido un retiro falla
    error KipuBank_withdrawalFailed(address caller);
    
    /*///////////////////////
					Functions
	///////////////////////*/

    constructor(uint256 maxWithdrawal){
        i_maxWithdrawal = maxWithdrawal;
    }

    receive() external payable {}
    fallback() external payable{}

    /*
    @notice funcion que permite a un usuario depositar en su boveda
    @dev la funcion actualiza la boveda del usuario
    @dev la funcion actualiza el contador de depositos
    @dev la funcion emite un evento de deposito
    @dev la funcion revierte si el deposito hace que el usuario supere el maximo de su boveda
    */
    function deposit() external payable {
        if (msg.value + s_vaults[msg.sender] > MAX_VAULT) revert KipuBank_bankCapped(msg.sender);
        _updateVault(msg.sender, s_vaults[msg.sender] + msg.value);
        s_deposits += 1;
        emit KipuBank_deposit(msg.sender,msg.value);
    }

    /*
    @notice funcion que permite a un usuario retirar de su boveda
    @dev la funcion actualiza la boveda del usuario
    @dev la funcion actualiza el contador de retiros
    @dev la funcion emite un evento de retiro
    @dev la funcion revierte si el usuario quiere retirar mas fondos de los que posee
    @dev la funcion revierte si el usuario quiere retirar mas fondos de lo permitido por el banco
    @dev la funcion revierte si la transferencia de fondos falla
    */
    function withdrawal(uint256 quant) external{
        if (quant > s_vaults[msg.sender]) revert KipuBank_unsuficentFunds(msg.sender);
        if (quant > i_maxWithdrawal) revert KipuBank_withdrawalCapped(msg.sender);
        _updateVault(msg.sender, s_vaults[msg.sender] - quant);
        s_withdrawals += 1;
        address payable recipient = payable(msg.sender);
        (bool success, ) = recipient.call{value: quant}("");
        if (!success) revert KipuBank_withdrawalFailed(msg.sender);
        emit KipuBank_withdrawal(msg.sender, quant);
    }

    /*
    @notice funcion privada que actualiza la boveda de un usuario a un nuevo valor
    */
    function _updateVault(address user, uint256 newBalance) private {
        s_vaults[user] = newBalance;
    }

    /*
    @notice funcion que permite a un usuario ver la cantidad total de retiros realizados
    @return uint256 cantidad total de retiros realizados
    */
    function viewWithdrawals() external view returns(uint256){
        return s_withdrawals;
    }

    /*
    @notice funcion que permite a un usuario ver la cantidad total de depositos realizados
    @return uint256 cantidad total de depositos realizados
    */
    function viewDeposits() external view returns(uint256){
        return s_deposits;
    }

    /*
    @notice funcion que permite a un usuario ver el saldo actual de su boveda
    @return uint256 saldo actual de la boveda del usuario
    */
    function viewVault() external view returns(uint256){
        return s_vaults[msg.sender];
    }
}