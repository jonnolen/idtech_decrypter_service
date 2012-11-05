require 'bundler/setup'
require 'sinatra'

require_relative 'idtechdecrypter'




configure do
	mime_type :bin, 'application/octet-stream'

	# this is the bdk for the idtech unimagII/Shuttle user manual and the ansi spec.
	set :bdk, "0123456789ABCDEFFEDCBA9876543210"

	# this is the encrypted payload from the idtech unimagII/Shuttle user manual
	set :sample_hex, ["02D500801F3723008383252A353135302A2A2A2A2A2A2A2A373836315E50415950415353" + 
		"2F4D4153544552434152445E2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A3F2A3B35313530" +  
		"2A2A2A2A2A2A2A2A373836313D2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A3F2AA096A" +
		"6F5D1DCBE45B5F77EB2559FEE0411013232E3F42044C0397E3E9E6D9B3A11FB8ADE07" + 
		"12AFD097C23AA86DFDC9DBA0E73A6FD698FD2F80800C0E1E9ED1BEED5EEA9840DA" + 
		"53F41254FDB79E89B76B127C25FE44AE7524BAEB5BDAACF777FA313233343536373839" + 
		"30FFFF9876543210E0004ABBF903"].pack("H*")

	set :decrypter, IDTechDecrypter.new(settings.bdk)
end

#to test using the unimagII/shuttle data send
# track 	= "A096A6F5D1DCBE45B5F77EB2559FEE0411013232E3F42044C0397E3E9E6D9B3A11FB8ADE0712AFD097C23AA86DFDC9DBA0E73A6FD698FD2F"
# ksn 		= "FFFF9876543210E0004A"
# algorith 	= "TDES"

post '/idtech/unimag/:algorithm/decrypt' do |algorithm|
	track = params[:track]
	ksn = params[:ksn]

	[settings.decrypter.decrypt(track, ksn, algorithm.upcase.to_sym)].pack("H*")
	# ipek = @decrypter.derive_IPEK(settings.bdk, ksn)
	# dek = @decrypter.derive_DEK(ipek, ksn)
	# if (algorithm.downcase == "aes")
	# 	[@decrypter.aes_decrypt(dek, track)].pack("H*")
	# else
	# 	[@decrypter.triple_des_decrypt(dek, track)].pack("H*")
	# end
end

get '/swipe' do
	settings.sample_hex
end

get '/swipe/file' do
	content_type :bin
	attachment 'swipe.bin'
	settings.sample_hex
end

