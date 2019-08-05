module Ruby
	module Anmat
		class Traceability

			def initialize(args={}, environment = :test)
				@environment 		= environment
				@f_evento 			= args["f_evento"] 		|| "20/01/2013" 
				@h_evento 			= args["h_evento"] 		|| "23:59"
				@gln_origen 		= args["gln_origen"] 	|| "glnws"
				@gln_destino 		= args["gln_destino"] 	|| "GLN-1"
				@n_remito 			= args["n_remito"] 		|| "1"
				@n_factura 			= args["n_factura"] 	|| "1"
				@vencimiento 		= args["vencimiento"] 	|| "01/05/2011"
				@gtin 				= args["gtin"] 			|| "GTIN1"
				@lote 				= args["lote"] 			|| "1"
				@numero_serial 		= args["numero_serial"] || rand(1300..99999999).to_s
				@id_evento 			= args["id_evento"] 	|| "133"
				@n_postal 			= args["n_postal"] 		|| "1416"
				@telefono 			= args["telefono"] 		|| "45880712"

				@user 				= 'pruebasws'
				@pass 				= 'pruebasws'
			end

			def set_client
				@client = Savon.client(
			        wsdl:  Anmat::URLS[@environment][:wsdl],
			        namespaces: Anmat::NAMESPACES,
			        log_level:  :debug,
			        ssl_verify_mode: :none,
			        read_timeout: 90,
			        open_timeout: 90,
			        headers: { "Accept-Encoding" => "gzip, deflate", "Connection" => "Keep-Alive" }
			    )
			end

			def send_medicamentos
				set_client
				body = set_body

				response = @client.call(:send_medicamentos, message: body)
				pp response
			end

			def set_body
				{
					"arg0" => {
						"f_evento" 			=> @f_evento,
						"h_evento" 			=> @h_evento,
						"gln_origen" 		=> @gln_origen,
						"gln_destino" 		=> @gln_destino,
						"n_remito" 			=> @n_remito,
						"n_factura" 		=> @n_factura,
						"vencimiento" 		=> @vencimiento,
						"gtin" 				=> @gtin,
						"lote" 				=> @lote,
						"numero_serial" 	=> @numero_serial,
						"id_evento" 		=> @id_evento,
						"n_postal" 			=> @n_postal,
						"telefono" 			=> @telefono,
					},
					"arg1" => @user,
					"arg2" => @pass
				}
			end
		end
	end
end
