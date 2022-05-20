# ######## Ex 10b
# # 可组合性
# 这个练习是作为 ex10 的补充部署的，但您并不知道在哪里
# 使用 ex10 找到它的地址，然后 voyager 从 ex10b 中读取
# 然后用ex10来领取积分

%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero, assert_le
from starkware.starknet.common.syscalls import get_contract_address, get_caller_address
from contracts.utils.Iex10 import Iex10

#
# 宣告存储变量
# 默认情况下，存储变量通过 ABI 是不可见的。 它们类似于 Solidity 中的“private”变量
#

@storage_var
func ex10_address_storage() -> (ex10_address_storage : felt):
end

@storage_var
func secret_value_storage() -> (secret_value_storage : felt):
end

#
# 只读函数
#
@view
func ex10_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    ex10_address : felt
):
    let (ex10_address) = ex10_address_storage.read()
    return (ex10_address)
end

@view
func secret_value{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    secret_value : felt
):
    let (secret_value) = secret_value_storage.read()
    return (secret_value)
end

#
# 建构函数
#
@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ex10_address : felt
):
    ex10_address_storage.write(ex10_address)
    let (current_contract_address) = get_contract_address()
    Iex10.set_ex_10b_address(
        contract_address=ex10_address, ex_10b_address_=current_contract_address
    )
    return ()
end

#
# 外部函数
# 呼叫此函数，指定地址将得2分
#

@external
func change_secret_value{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    new_secret_value : felt
):
    # 只有ex10可以呼叫这个函数
    only_ex10()
    # 更改秘密值
    secret_value_storage.write(new_secret_value)
    return ()
end

#
# 内部函数
#
#
func only_ex10{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    let (caller) = get_caller_address()
    let (ex10_address) = ex10_address_storage.read()
    assert ex10_address = caller
    return ()
end
