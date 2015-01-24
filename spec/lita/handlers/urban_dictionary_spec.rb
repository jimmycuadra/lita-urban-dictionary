require "spec_helper"

describe Lita::Handlers::UrbanDictionary, lita_handler: true do
  it { is_expected.to route_command("ud foo").to(:define) }
  it { is_expected.to route_command("ud me foo").to(:define) }
  it { is_expected.to route_command("urbandictionary foo").to(:define) }
  it { is_expected.to route_command("urbandictionary me foo").to(:define) }
  it { is_expected.to route_command("urban dictionary foo").to(:define) }
  it { is_expected.to route_command("urban dictionary me foo").to(:define) }

  describe "#define" do
    let(:json) do
      %Q{{"list":[{"defid":1369633,"word":"robot","author":"Ralius","permalink"\
:"http://robot.urbanup.com/1369633","definition":"scariest fucking thing on \
earth.","example":"have you ever been to Chuck E. Cheese and looked behind the \
curtain?","thumbs_up":565,"thumbs_down":141,"current_vote":""}]}}
    end

    let(:json_no_example) do
      %Q{{"list":[{"defid":1369633,"word":"robot","author":"Ralius","permalink"\
:"http://robot.urbanup.com/1369633","definition":"scariest fucking thing on \
earth.","thumbs_up":565,"thumbs_down":141,"current_vote":""}]}}
    end

    let(:json_large) do
      %Q{{"list":[{"defid":1369633,"word":"robot","author":"Ralius","permalink"\
:"http://robot.urbanup.com/1369633","definition":"#{large_string}","example":\
"#{large_string}","thumbs_up":565,"thumbs_down":141,"current_vote":""}]}}
    end

    let(:json_large_example) do
      %Q{{"list":[{"defid":1369633,"word":"robot","author":"Ralius","permalink"\
:"http://robot.urbanup.com/1369633","definition":"scariest fucking thing on earth.","example":\
"#{large_string}","thumbs_up":565,"thumbs_down":141,"current_vote":""}]}}
    end

    let(:large_string) do
      30.times.map { |n| "#{n}" }.join("\\r\\n")
    end

    before do
      allow_any_instance_of(Faraday::Connection).to receive(:get)
    end

    it "responds with the definition of the word" do
      response = double("Faraday::Response", status: 200, body: json)
      allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(
        response
      )
      send_command("ud robot")
      expect(replies.last).to eq <<-DEF.chomp
robot: scariest fucking thing on earth.
Example: have you ever been to Chuck E. Cheese and looked behind the curtain?
DEF
    end

    it "doesn't include an example if none were received from the API" do
      response = double("Faraday::Response", status: 200, body: json_no_example)
      allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(
        response
      )
      send_command("ud robot")
      expect(replies.last).to eq("robot: scariest fucking thing on earth.")
    end

    it "truncates responses at 20 lines when the definition is very long" do
      response = double("Faraday::Response", status: 200, body: json_large)
      allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(response)
      send_command("ud lita bot")
      expect(replies.last.split("\n").size).to eq(21)
      expect(replies.last).to include("http://www.urbandictionary.com/define.php?term=lita%20bot")
    end

    it "truncates responses at 20 lines when the example is very long" do
      response = double("Faraday::Response", status: 200, body: json_large_example)
      allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(response)
      send_command("ud lita bot")
      expect(replies.last.split("\n").size).to eq(21)
      expect(replies.last).to include("http://www.urbandictionary.com/define.php?term=lita%20bot")
    end

    it "responds with a warning if no definition was found" do
      response = double("Faraday::Response", status: 200, body: "{}")
      allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(
        response
      )
      send_command("ud bar")
      expect(replies.last).to eq("No definition found for bar.")
    end

    it "responds with a warning if the API responded with a non-200 status" do
      response = double("Faraday::Response", status: 500)
      allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(
        response
      )
      send_command("ud bar")
      expect(replies.last).to eq("No definition found for bar.")
    end
  end
end
