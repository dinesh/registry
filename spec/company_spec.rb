
require_relative 'spec_helper'

describe Registry::Owner do
    let(:owner){ Registry::Owner.create(:name => 'test', company_id: 1) }

    context 'create' do
        it { owner.version.should == 1 }
        it { owner.versioned?.should be_true }
    end

    context 'update' do
        before do
            owner.update(name: 'test 2')
        end
        let(:v1){ owner.versions.first }
        let(:v2){ owner.versions.last }

        it { v2.modifications[:name].should eql(['test', 'test 2'])}
    end

end
