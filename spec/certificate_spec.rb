require_relative "./spec_helper"

describe SSHData::Certificate do
  let(:rsa_cert)     { described_class.parse(fixture("rsa_leaf_for_rsa_ca-cert.pub")) }
  let(:dsa_cert)     { described_class.parse(fixture("dsa_leaf_for_rsa_ca-cert.pub")) }
  let(:ecdsa_cert)   { described_class.parse(fixture("ecdsa_leaf_for_rsa_ca-cert.pub")) }
  let(:ed25519_cert) { described_class.parse(fixture("ed25519_leaf_for_rsa_ca-cert.pub")) }

  let(:rsa_ca_cert)     { described_class.parse(fixture("rsa_leaf_for_rsa_ca-cert.pub")) }
  let(:dsa_ca_cert)     { described_class.parse(fixture("rsa_leaf_for_dsa_ca-cert.pub")) }
  let(:ecdsa_ca_cert)   { described_class.parse(fixture("rsa_leaf_for_ecdsa_ca-cert.pub")) }
  let(:ed25519_ca_cert) { described_class.parse(fixture("rsa_leaf_for_ed25519_ca-cert.pub")) }

  let(:min_time) { Time.at(0) }
  let(:max_time) { Time.at((2**64)-1) }

  it "raises on trailing data" do
    algo, b64, host = fixture("rsa_leaf_for_rsa_ca-cert.pub").split(" ", 3)
    raw = Base64.decode64(b64)
    raw += "foobar"
    b64 = Base64.strict_encode64(raw)
    cert = [algo, b64, host].join(" ")

    expect {
      described_class.parse(cert)
    }.to raise_error(SSHData::DecodeError)
  end

  it "raises on type mismatch" do
    _, b64, host = fixture("rsa_leaf_for_rsa_ca-cert.pub").split(" ", 3)
    cert = [SSHData::Certificate::ALGO_ED25519, b64, host].join(" ")

    expect {
      described_class.parse(cert)
    }.to raise_error(SSHData::DecodeError)
  end

  it "doesn't require the user/host names" do
    type, b64, _ = fixture("rsa_leaf_for_rsa_ca-cert.pub").split(" ", 3)
    cert = [type, b64].join(" ")

    expect {
      described_class.parse(cert)
    }.not_to raise_error
  end

  it "parses RSA certs" do
    expect(rsa_cert.algo).to eq(SSHData::Certificate::ALGO_RSA)
    expect(rsa_cert.nonce).to be_a(String)
    expect(rsa_cert.key_data).to be_a(Hash)
    expect(rsa_cert.serial).to eq(123)
    expect(rsa_cert.type).to eq(SSHData::Certificate::TYPE_USER)
    expect(rsa_cert.key_id).to eq("my-ident")
    expect(rsa_cert.valid_principals).to eq("\x00\x00\x00\x0Cmy-principal")
    expect(rsa_cert.valid_after).to eq(min_time)
    expect(rsa_cert.valid_before).to eq(max_time)
    expect(rsa_cert.critical_options).to eq("\x00\x00\x00\x03foo\x00\x00\x00\x07\x00\x00\x00\x03bar")
    expect(rsa_cert.extensions).to eq("\x00\x00\x00\x03baz\x00\x00\x00\x08\x00\x00\x00\x04qwer")
    expect(rsa_cert.reserved).to eq("")
    expect(rsa_cert.signature_key).to be_a(String)
    expect(rsa_cert.signature).to be_a(String)
  end

  it "parses DSA certs" do
    expect(dsa_cert.algo).to eq(SSHData::Certificate::ALGO_DSA)
    expect(dsa_cert.nonce).to be_a(String)
    expect(dsa_cert.key_data).to be_a(Hash)
    expect(dsa_cert.serial).to eq(123)
    expect(dsa_cert.type).to eq(SSHData::Certificate::TYPE_USER)
    expect(dsa_cert.key_id).to eq("my-ident")
    expect(dsa_cert.valid_principals).to eq("\x00\x00\x00\x0Cmy-principal")
    expect(dsa_cert.valid_after).to eq(min_time)
    expect(dsa_cert.valid_before).to eq(max_time)
    expect(dsa_cert.critical_options).to eq("\x00\x00\x00\x03foo\x00\x00\x00\x07\x00\x00\x00\x03bar")
    expect(dsa_cert.extensions).to eq("\x00\x00\x00\x03baz\x00\x00\x00\x08\x00\x00\x00\x04qwer")
    expect(dsa_cert.reserved).to eq("")
    expect(dsa_cert.signature_key).to be_a(String)
    expect(dsa_cert.signature).to be_a(String)
  end

  it "parses ECDSA certs" do
    expect(ecdsa_cert.algo).to eq(SSHData::Certificate::ALGO_ECDSA256)
    expect(ecdsa_cert.nonce).to be_a(String)
    expect(ecdsa_cert.key_data).to be_a(Hash)
    expect(ecdsa_cert.serial).to eq(123)
    expect(ecdsa_cert.type).to eq(SSHData::Certificate::TYPE_USER)
    expect(ecdsa_cert.key_id).to eq("my-ident")
    expect(ecdsa_cert.valid_principals).to eq("\x00\x00\x00\x0Cmy-principal")
    expect(ecdsa_cert.valid_after).to eq(min_time)
    expect(ecdsa_cert.valid_before).to eq(max_time)
    expect(ecdsa_cert.critical_options).to eq("\x00\x00\x00\x03foo\x00\x00\x00\x07\x00\x00\x00\x03bar")
    expect(ecdsa_cert.extensions).to eq("\x00\x00\x00\x03baz\x00\x00\x00\x08\x00\x00\x00\x04qwer")
    expect(ecdsa_cert.reserved).to eq("")
    expect(ecdsa_cert.signature_key).to be_a(String)
    expect(ecdsa_cert.signature).to be_a(String)
  end

  it "parses ED25519 certs" do
    expect(ed25519_cert.algo).to eq(SSHData::Certificate::ALGO_ED25519)
    expect(ed25519_cert.nonce).to be_a(String)
    expect(ed25519_cert.key_data).to be_a(Hash)
    expect(ed25519_cert.serial).to eq(123)
    expect(ed25519_cert.type).to eq(SSHData::Certificate::TYPE_USER)
    expect(ed25519_cert.key_id).to eq("my-ident")
    expect(ed25519_cert.valid_principals).to eq("\x00\x00\x00\x0Cmy-principal")
    expect(ed25519_cert.valid_after).to eq(min_time)
    expect(ed25519_cert.valid_before).to eq(max_time)
    expect(ed25519_cert.critical_options).to eq("\x00\x00\x00\x03foo\x00\x00\x00\x07\x00\x00\x00\x03bar")
    expect(ed25519_cert.extensions).to eq("\x00\x00\x00\x03baz\x00\x00\x00\x08\x00\x00\x00\x04qwer")
    expect(ed25519_cert.reserved).to eq("")
    expect(ed25519_cert.signature_key).to be_a(String)
    expect(ed25519_cert.signature).to be_a(String)
  end

  it "parses certs issued by RSA CAs" do
    expect(rsa_ca_cert.algo).to eq(SSHData::Certificate::ALGO_RSA)
    expect(rsa_ca_cert.nonce).to be_a(String)
    expect(rsa_ca_cert.key_data).to be_a(Hash)
    expect(rsa_ca_cert.serial).to eq(123)
    expect(rsa_ca_cert.type).to eq(SSHData::Certificate::TYPE_USER)
    expect(rsa_ca_cert.key_id).to eq("my-ident")
    expect(rsa_ca_cert.valid_principals).to eq("\x00\x00\x00\x0Cmy-principal")
    expect(rsa_ca_cert.valid_after).to eq(min_time)
    expect(rsa_ca_cert.valid_before).to eq(max_time)
    expect(rsa_ca_cert.critical_options).to eq("\x00\x00\x00\x03foo\x00\x00\x00\x07\x00\x00\x00\x03bar")
    expect(rsa_ca_cert.extensions).to eq("\x00\x00\x00\x03baz\x00\x00\x00\x08\x00\x00\x00\x04qwer")
    expect(rsa_ca_cert.reserved).to eq("")
    expect(rsa_ca_cert.signature_key).to be_a(String)
    expect(rsa_ca_cert.signature).to be_a(String)
  end

  it "parses certs issued by DSA CAs" do
    expect(dsa_ca_cert.algo).to eq(SSHData::Certificate::ALGO_RSA)
    expect(dsa_ca_cert.nonce).to be_a(String)
    expect(dsa_ca_cert.key_data).to be_a(Hash)
    expect(dsa_ca_cert.serial).to eq(123)
    expect(dsa_ca_cert.type).to eq(SSHData::Certificate::TYPE_USER)
    expect(dsa_ca_cert.key_id).to eq("my-ident")
    expect(dsa_ca_cert.valid_principals).to eq("\x00\x00\x00\x0Cmy-principal")
    expect(dsa_ca_cert.valid_after).to eq(min_time)
    expect(dsa_ca_cert.valid_before).to eq(max_time)
    expect(dsa_ca_cert.critical_options).to eq("\x00\x00\x00\x03foo\x00\x00\x00\x07\x00\x00\x00\x03bar")
    expect(dsa_ca_cert.extensions).to eq("\x00\x00\x00\x03baz\x00\x00\x00\x08\x00\x00\x00\x04qwer")
    expect(dsa_ca_cert.reserved).to eq("")
    expect(dsa_ca_cert.signature_key).to be_a(String)
    expect(dsa_ca_cert.signature).to be_a(String)
  end

  it "parses certs issued by ECDSA CAs" do
    expect(ecdsa_ca_cert.algo).to eq(SSHData::Certificate::ALGO_RSA)
    expect(ecdsa_ca_cert.nonce).to be_a(String)
    expect(ecdsa_ca_cert.key_data).to be_a(Hash)
    expect(ecdsa_ca_cert.serial).to eq(123)
    expect(ecdsa_ca_cert.type).to eq(SSHData::Certificate::TYPE_USER)
    expect(ecdsa_ca_cert.key_id).to eq("my-ident")
    expect(ecdsa_ca_cert.valid_principals).to eq("\x00\x00\x00\x0Cmy-principal")
    expect(ecdsa_ca_cert.valid_after).to eq(min_time)
    expect(ecdsa_ca_cert.valid_before).to eq(max_time)
    expect(ecdsa_ca_cert.critical_options).to eq("\x00\x00\x00\x03foo\x00\x00\x00\x07\x00\x00\x00\x03bar")
    expect(ecdsa_ca_cert.extensions).to eq("\x00\x00\x00\x03baz\x00\x00\x00\x08\x00\x00\x00\x04qwer")
    expect(ecdsa_ca_cert.reserved).to eq("")
    expect(ecdsa_ca_cert.signature_key).to be_a(String)
    expect(ecdsa_ca_cert.signature).to be_a(String)
  end

  it "parses certs issued by ED25519 CAs" do
    expect(ed25519_ca_cert.algo).to eq(SSHData::Certificate::ALGO_RSA)
    expect(ed25519_ca_cert.nonce).to be_a(String)
    expect(ed25519_ca_cert.key_data).to be_a(Hash)
    expect(ed25519_ca_cert.serial).to eq(123)
    expect(ed25519_ca_cert.type).to eq(SSHData::Certificate::TYPE_USER)
    expect(ed25519_ca_cert.key_id).to eq("my-ident")
    expect(ed25519_ca_cert.valid_principals).to eq("\x00\x00\x00\x0Cmy-principal")
    expect(ed25519_ca_cert.valid_after).to eq(min_time)
    expect(ed25519_ca_cert.valid_before).to eq(max_time)
    expect(ed25519_ca_cert.critical_options).to eq("\x00\x00\x00\x03foo\x00\x00\x00\x07\x00\x00\x00\x03bar")
    expect(ed25519_ca_cert.extensions).to eq("\x00\x00\x00\x03baz\x00\x00\x00\x08\x00\x00\x00\x04qwer")
    expect(ed25519_ca_cert.reserved).to eq("")
    expect(ed25519_ca_cert.signature_key).to be_a(String)
    expect(ed25519_ca_cert.signature).to be_a(String)
  end
end
