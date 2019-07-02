require 'test_helper'

class SpgatewayNotificationWithDifferentMerchantHashTest < Test::Unit::TestCase
  include OffsitePayments::Integrations

  def setup
    @spgateway = Spgateway::Notification.new(http_raw_data)
  end

  def test_params
    p = @spgateway.params

    assert_equal 23, p.size
    assert_equal 'CREDIT', p['PaymentType']
    assert_equal '440524E95B5D40F4D2CB0442104DE8D74196BD4D6D9B33B773E2388234DF824B', p['CheckCode']
    assert_equal '2019-07-02 17:00:38', p['PayTime']
  end

  def test_complete?
    assert @spgateway.complete?
  end

  def test_checksum_ok?
    merchant_hash_key = "fkUea2sZawehznHFtgs2UOOLhQ6oC7Oc"
    merchant_hash_iv = "Cku48ghNIe1SZQTP"
    assert @spgateway.checksum_ok? merchant_hash_key, merchant_hash_iv

    # Should preserve mac value
    assert @spgateway.params['CheckCode'].present?
  end

  private

    def http_raw_data
      # Sample notification from test environment
      "Status=SUCCESS&Message=%E6%8E%88%E6%AC%8A%E6%88%90%E5%8A%9F&MerchantID=MS36597310&Amt=500&TradeNo=19070217003866771&MerchantOrderNo=709321562058023&RespondType=String&CheckCode=440524E95B5D40F4D2CB0442104DE8D74196BD4D6D9B33B773E2388234DF824B&IP=118.160.53.94&EscrowBank=HNCB&PaymentType=CREDIT&PayTime=2019-07-02+17%3A00%3A38&RespondCode=00&Auth=377949&Card6No=400022&Card4No=1111&Exp=2505&TokenUseStatus=9&InstFirst=0&InstEach=0&Inst=0&ECI=&PaymentMethod=CREDIT"
    end
end
