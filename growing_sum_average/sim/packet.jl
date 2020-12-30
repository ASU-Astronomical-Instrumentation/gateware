N=17
Val = split("I0"^N * "I1"^N * "Q0"^N * "Q1"^N, "")

for ind in 1:(length(Val)+8+1+1)
    if mod(ind,18) == 0
        insert!(Val,ind,"\n")
    elseif mod(ind, 9) == 0
        insert!(Val,ind," ")
    end
end

Eth_data = join(Val)
println("\nPackets")
print(Eth_data * " ...")

using Printf
@printf("\n\n-> Packet Density without close packing is %.2F%% (!)", 100*N/(8*ceil(N/8)))