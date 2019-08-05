module Ruby
	module Anmat
		class Traceability

			def initialize(args= {}, environment = :test)
				@environment 		= environment
				@usuartio_laboratorio_2	= args[:usuartio_laboratorio_2] 	|| '9999999999918'
				@pass_laboratorio_2 	= args[:pass_laboratorio_2] 	 	|| 'Pami1111'
				@gln_laboratorio_2		= args[:gln_laboratorio_2] 	 		|| '9999999999918'

				@usuario_laboratorio_1 	= args[:usuario_laboratorio_1] 		|| 'pruebasws'
				@pass_laboratorio_1 	= args[:pass_laboratorio_1] 		|| 'pruebasws'
				@gln_laboratorio_1 		= args[:gln_laboratorio_1] 			|| 'glnws'

				@gln_drogueria 			= args[:gln_drogueria] 				|| "9999999999925";
			end

			def set_client
				@client = Savon.client(
			        wsdl:  Anmat::URLS[@environment][:wsdl],
			        endpoint: 'https://servicios.pami.org.ar/trazamed.WebService',
			        wsse_auth: ['testwservice', 'testwservicepsw'],
			        namespaces: Anmat::NAMESPACES,
			        namespace_identifier: :ns1,
			        log: true,
			        log_level:  :debug,
			        pretty_print_xml: true,
			        headers: { "Accept-Encoding" => "gzip, deflate", "Connection" => "close" }
			    )
			end

			def responder(response)
				pp response
				errores = ""
				id_transaccion = ""
				resultado = ""
				transacciones = []
				if response[:return]
					resultado 		= response[:return][:resultado]
					id_transaccion  = response[:return][:codigo_transaccion] || response[:return][:id_transac_asociada]
					transacciones 	= response[:return][:list]
					if response[:return][:errores]
						response[:return][:errores].each do |k,v|
							if v.is_a?(Array)
								errores << "Código: " + v['_c_error'] + ". - Descripción: " + v['_d_error'] +".\n"
							else
								errores << v + "-"
							end
						end
					end
				end
				return {resultado: resultado, id_transaccion: id_transaccion, transacciones: transacciones, errores: errores}
			end

			def send_medicamentos(args={})
				set_client
				random_serial = rand(1300..99999999)
				body = {
					"arg0" => {
						"f_evento"				=> args[:f_evento] 				|| "20/01/2013" ,
						"h_evento"				=> args[:h_evento] 				|| "13:15",
						"gln_origen"			=> args[:gln_origen] 			|| @gln_laboratorio_2,
						"gln_destino"			=> args[:gln_destino] 			|| @gln_laboratorio_1,
						"n_remito"				=> args[:n_remito] 				|| "R000100001235",
						"n_factura"				=> args[:n_factura] 			|| "R000100001235",
						"vencimiento"			=> args[:vencimiento] 			|| "01/05/2011",
						"gtin"					=> args[:gtin] 					|| "GTIN2",
						"lote"					=> args[:lote] 					|| "1",
						"desde_numero_serial" 	=> args[:desde_numero_serial] 	|| random_serial,
						"hasta_numero_serial" 	=> args[:hasta_numero_serial] 	|| random_serial + 10,
						"id_evento"				=> args[:id_evento] 			|| "133",
						"n_postal"				=> args[:n_postal] 				|| "1416",
						"telefono"				=> args[:telefono] 				|| "45880712"
					},
					"arg1" => @usuartio_laboratorio_2,
					"arg2" => @pass_laboratorio_2
				}

				response = @client.call(:send_medicamentos_dh_serie, message: body)
				return responder(response.body[:send_medicamentos_dh_serie_response])
			end

			def cancelar_transaccion(id)
				set_client
				body = {"arg0" => id, "arg1" => @usuartio_laboratorio_2, "arg2" => @pass_laboratorio_2}
				response = @client.call(:send_cancelac_transacc, message: body)
				return responder(response.body[:send_cancelac_transacc_response])
			end

			def consultar_stock(args={}, user, pass)
				client = set_client
				body = {
					"arg0" => user,
					"arg1" => pass,
					"arg2" => args[:gtin] || 'GTIN1',
					"arg3" => args[:gln] || 'glnws',
					"arg4" => args[:medicine] || 'GTIN1',
					"arg5" => args[:quantity] || 5,
					"arg6" => args[:m_presentation],
					"arg7" => args[:batch],
					"arg8" => args[:serial],
					"arg9" => args[:page],
					"arg10" => args[:per_page]
				}

				response = @client.call(:get_consulta_stock, message: body)
			end

			def transacciones_no_confirmadas(args={})
				set_client
				body = {
					"args0" 	=> @usuario_laboratorio_1,
					"args1" 	=> @pass_laboratorio_1,
					"args2" 	=> args[:id_transaccion] 			|| -1,
					"args3" 	=> args[:gln_informador],
					"args4" 	=> args[:gln_origen]				|| @gln_laboratorio_2,
					"args5" 	=> args[:gln_destino]				|| @gln_laboratorio_1,
					"args6" 	=> args[:gtin],
					"args7" 	=> args[:id_evento]					|| -1,
					"args8" 	=> args[:fecha_ope_dede],
					"args9" 	=> args[:fecha_ope_hasta],
					"args10" 	=> args[:fecha_trans_desde],
					"args11" 	=> args[:fecha_trans_hasta],
					"args12" 	=> args[:fecha_vencimiento_desde],
					"args13" 	=> args[:fecha_vencimiento_hasta],
					"args14" 	=> args[:n_remito],
					"args15" 	=> args[:n_factura],
					"args16" 	=> args[:estado_transaccion]		|| -1,
					"args17" 	=> args[:p1],
					"args18" 	=> args[:p2]
				}
				response = @client.call(:get_transacciones_no_confirmadas, message: body)
				return responder(response.body[:get_transacciones_no_confirmadas_response])
			end
		end
	end
end
