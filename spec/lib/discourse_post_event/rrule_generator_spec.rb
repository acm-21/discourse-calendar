# frozen_string_literal: true

describe RRuleGenerator do
  let(:time) { Time.now }

  before { freeze_time Time.utc(2020, 8, 12, 16, 32) }

  describe "every week" do
    context "when a rule and time are given" do
      let(:time) { Time.utc(2020, 8, 10, 16, 32) }

      it "generates the rule" do
        rrule = RRuleGenerator.generate(time, recurrence_type: "every_week").first
        expect(rrule.to_s).to eq("2020-08-17 16:32:00 UTC")
      end
    end
  end

  context "when tzid given" do
    it "it correctly computes the next date using the timezone" do
      tzid = "Europe/Paris"
      time = Time.utc(2020, 1, 25, 15, 36)

      freeze_time DateTime.parse("2020-02-25 15:36")

      rrule = RRuleGenerator.generate(time, tzid: tzid, recurrence_type: "every_week").first
      expect(rrule.to_s).to eq("2020-02-29 15:36:00 +0100")

      freeze_time DateTime.parse("2020-09-25 15:36")

      rrule = RRuleGenerator.generate(time, tzid: tzid).first
      expect(rrule.to_s).to eq("2020-09-26 15:36:00 +0200")
    end
  end

  describe "every day" do
    context "when a rule and time are given" do
      it "generates the rule" do
        rrule = RRuleGenerator.generate(time, recurrence_type: "every_day").first
        expect(rrule.to_s).to eq("2020-08-13 16:32:00 UTC")
      end

      context "when the given time is a valid next" do
        let(:time) { Time.utc(2020, 8, 10, 16, 32) }

        it "returns the next valid after given time and in the future" do
          rrule = RRuleGenerator.generate(time, recurrence_type: "every_day").first
          expect(rrule.to_s).to eq("2020-08-12 16:32:00 UTC")
        end
      end
    end
  end
end
