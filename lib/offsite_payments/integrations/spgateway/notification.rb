# encoding: utf-8
require 'digest'

module OffsitePayments #:nodoc:
  module Integrations #:nodoc:
    module Spgateway
      class Notification < OffsitePayments::Notification
        PARAMS_FIELDS = %w(
          Status Message MerchantID Amt TradeNo MerchantOrderNo PaymentType RespondType CheckCode PayTime IP
          EscrowBank TokenUseStatus RespondCode Auth Card6No Card4No Inst InstFirst InstEach ECI PayBankCode
          PayerAccount5Code CodeNo BankCode Barcode_1 Barcode_2 Barcode_3 ExpireDate CheckCode
        )

        PARAMS_FIELDS.each do |field|
          define_method field.underscore do
            @params[field]
          end
        end

        def success?
          status == 'SUCCESS'
        end

        # TODO 使用查詢功能實作 acknowledge
        # Pay2go 沒有遠端驗證功能，
        # 而以 checksum_ok? 代替
        def acknowledge
          checksum_ok?
        end

        def complete?
          %w(SUCCESS CUSTOM).include? status
        end

        def checksum_ok?(hash_key = nil, hash_iv = nil)
          raw_data = URI.encode_www_form OffsitePayments::Integrations::Spgateway::CHECK_CODE_FIELDS.sort.map { |field|
            [field, @params[field]]
          }

          hash_iv ||= OffsitePayments::Integrations::Spgateway.hash_iv
          hash_key ||= OffsitePayments::Integrations::Spgateway.hash_key

          hash_raw_data = "HashIV=#{hash_iv}&#{raw_data}&HashKey=#{hash_key}"
          Digest::SHA256.hexdigest(hash_raw_data).upcase == check_code
        end

        private

          def parse(post)
            @raw = post.to_s

            for line in CGI.unescape(@raw).split('&')
              key, value = *line.scan( %r{^([A-Za-z0-9_.-]+)\=(.*)$} ).flatten
              params[key] = value.to_s if key.present?
            end
          end
      end
    end
  end
end
