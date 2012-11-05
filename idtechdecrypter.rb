require 'bundler/setup'
require 'dukpt'

class IDTechDecrypter
	include DUKPT::Encryption

	def initialize (bdk)
		@bdk = bdk
	end

	def decrypt(cryptogram, ksn, algorithm = :TDES)
		ipek = derive_IPEK(@bdk, ksn)
		dek = derive_DEK(ipek, ksn)

		if (algorithm == :AES)
			aes_decrypt( dek, cryptogram)
		else
			triple_des_decrypt(dek, cryptogram)
		end
	end
end