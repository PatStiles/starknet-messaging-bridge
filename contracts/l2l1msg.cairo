%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.messages import send_message_to_l1

@storage_var
func l1_nft_address_storage() -> (l1_nft_address : felt):
end

@storage_var
func l1_assigned_var_storage() -> (l1_assigned_var : felt):
end

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    l1_nft_address : felt
):
    l1_nft_address_storage.write(l1_nft_address)
    return ()
end

@external
func create_l1_nft_message{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    l1_user : felt
):
    let (message_payload : felt*) = alloc()
    assert message_payload[0] = l1_user
    let (l1_contract_address) = l1_nft_address_storage.read()
    send_message_to_l1(to_address=l1_contract_address, payload_size=1, payload=message_payload)
    return ()
end

@l1_handler
func l1_assigned_var_handler{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    from_address : felt, var : felt
):
    l1_assigned_var_storage.write(var)
    return ()
end

@external
func l1_assigned_var{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    assigned_var : felt
):
    let (var) = l1_assigned_var_storage.read()
    return (assigned_var=var)
end
