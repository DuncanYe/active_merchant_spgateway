# encoding: utf-8
require 'digest'

module OffsitePayments #:nodoc:
  module Integrations #:nodoc:
    module Spgateway
      class Helper < OffsitePayments::Helper
        FIELDS = %w(
          MerchantID HashKey HashIv LangType MerchantOrderNo Amt ItemDesc TradeLimit ExpireDate ReturnURL NotifyURL CustomerURL ClientBackURL Email EmailModify LoginType OrderComment CREDIT CreditRed InstFlag UNIONPAY WEBATM VACC CVS BARCODE CUSTOM TokenTerm
        )

        FIELDS.each do |field|
          mapping field.underscore.to_sym, field
        end
        mapping :account, 'MerchantID' # AM common
        mapping :amount, 'Amt' # AM common

        def initialize(order, account, options = {})
          super
          add_field 'Version', OffsitePayments::Integrations::Spgateway::VERSION
          add_field 'RespondType', OffsitePayments::Integrations::Spgateway::RESPOND_TYPE
          OffsitePayments::Integrations::Spgateway::CONFIG.each do |field|
            add_field field, OffsitePayments::Integrations::Spgateway.send(field.underscore.to_sym)
          end
        end
        def time_stamp(date)
          add_field 'TimeStamp', date.to_time.to_i
        end
        def encrypted_data hash_key = nil, hash_iv = nil
          raw_data = URI.encode_www_form OffsitePayments::Integrations::Spgateway::CHECK_VALUE_FIELDS.sort.map { |field|
            [field, @fields[field]]
          }

          @fields['HashKey'] ||= (hash_key || OffsitePayments::Integrations::Spgateway.hash_key)
          @fields['HashIv'] ||= (hash_iv || OffsitePayments::Integrations::Spgateway.hash_iv)

          hash_raw_data = "HashKey=#{@fields['HashKey']}&#{raw_data}&HashIV=#{@fields['HashIv']}"
          add_field 'CheckValue', Digest::SHA256.hexdigest(hash_raw_data).upcase

          # 因為 OffsitePayments::ActionViewHelper 會把 `@fields` 迭代塞入表單裡面，
          # 導致 HTTP POST request 帶了 HashKey 跟 HashIV 資訊。
          # source: https://git.io/fji0Z
          @fields['HashKey'] = nil
          @fields['HashIv'] = nil
        end
      end

    end
  end
end
