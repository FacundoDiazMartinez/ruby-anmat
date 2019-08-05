module Ruby
	module Anmat

		URLS = {
		    :test => {
		        :wsdl => 'https://servicios.pami.org.ar/trazamed.WebService?WSDL'
		    },
		    :production => {
		        :wsdl => 'https://trazabilidad.pami.org.ar:9050/trazamed.WebService'
		    }
	    }

	    NAMESPACES = {
	    	'SOAP-ENV' => 'http://schemas.xmlsoap.org/soap/envelope/',
			'xsd' => 'http://www.w3.org/2001/XMLSchema',
			'xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
			'SOAP-ENC' => 'http://schemas.xmlsoap.org/soap/encoding/'
	    }

	end
end