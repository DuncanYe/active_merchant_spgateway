# encoding: utf-8
require 'test_helper'

class SpgatewayHelperWithMerchantHashTest < Test::Unit::TestCase
  include OffsitePayments::Integrations

  def setup
  end

  def test_check_value
    @helper = Spgateway::Helper.new 'sdfasdfa', '123456'
    @helper.add_field 'Amt', '500'
    @helper.add_field 'MerchantID', 'MS36595603'
    @helper.add_field 'MerchantOrderNo','709321562558751'
    @helper.add_field 'TimeStamp', '1403243286'
    @helper.add_field 'Version', '1.2'

    OffsitePayments::Integrations::Spgateway.hash_key = 'GADlNOKdHiTBjdgW6uAjngF9ItT6nCW4'
    OffsitePayments::Integrations::Spgateway.hash_iv = 'dzq1naf5t8HMmXIs'

    merchant_hash_key = "fkUea2sZawehznHFtgs2UOOLhQ6oC7Oc"
    merchant_hash_iv = "Cku48ghNIe1SZQTP"

    @helper.encrypted_data merchant_hash_key, merchant_hash_iv
    # HashKey=fkUea2sZawehznHFtgs2UOOLhQ6oC7Oc&Amt=500&MerchantID=MS36595603&MerchantOrderNo=709321562558751&TimeStamp=1403243286&Version=1.2&HashIV=Cku48ghNIe1SZQTP
    assert_equal '693D810065089DF99A74D978DAE53194DEB8B841F0359C91E29A2DFC8BF35D63', @helper.fields['CheckValue']
    assert_equal nil, @helper.fields['HashKey']
    assert_equal nil, @helper.fields['HashIv']
  end

end
