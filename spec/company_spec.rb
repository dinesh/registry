
require_relative 'spec_helper'

describe Registry::Owner do
    let(:owner){ Registry::Owner.create(:name => 'test', company_id: 1) }

    context 'create' do
        it { owner.version.should == 1 }
        it { owner.versioned?.should be_true }
    end

    context 'update' do
        before(:all) do
            owner.update(name: 'test 2')
            owner.update(name: 'test 3')
            owner.update(name: 'test 4')
        end

        let(:v1){ owner.versions.first }
        let(:v3){ owner.versions.last }

        it { v1.modifications[:name].should eql(['test', 'test 2']) }
        it { v3.modifications[:name].should eql(['test 3', 'test 4']) }

        context '#changes_between' do
            let(:changes){ owner.changes_between(v1, v3) }

            it { changes[:name].should eql(['test 2', 'test 4']) }

        end

    end

end
