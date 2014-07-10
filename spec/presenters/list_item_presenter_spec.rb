require 'spec_helper'

describe ListItemPresenter do
  let(:object) { double('object', id: 42, name: 'name', description: 'description', tags: ['a', 'b']) }
  let(:presenter) { ListItemPresenter.new object: object, ctx: double('ctx') }

  describe "general" do
    describe "#id" do
      it "gets the object id" do
        expect(presenter.id).to eq (object.id)
      end
    end

    describe "#name" do
      it "gets the object name" do
        expect(presenter.name).to eq (object.name)
      end
    end

    describe "#url" do
      it "gets the object url" do
        expect(presenter.ctx).to receive(:url_for).with(object).and_return 'url'
        expect(presenter.url).to eq ('url')
      end
    end

    describe "#checkbox" do
      describe "uses defined" do
        let(:presenter_) { ListItemPresenter.new object: object, ctx: double('ctx'), checkbox: true }
        it "gets the passed value" do
          expect(presenter_.checkbox?).to be true
        end
      end
      describe "uses default" do
        let(:presenter_) { ListItemPresenter.new object: object, ctx: double('ctx') }
        it "gets the default value" do
          expect(presenter_.checkbox?).to be false
        end
      end
    end

    describe "#class_name" do
      it "gets the object type and item size" do
        expect(presenter.ctx).to receive(:object_type).with(object).and_return 'type'
        expect(presenter.class_name).to eq 'type big'
      end
    end

    describe "#avatar" do
      it "gets the object avatar" do
        avatar_mock = double('avatar').as_null_object
        expect(object).to receive(:avatar).at_least(:once).and_return avatar_mock
        expect(presenter.ctx).to receive(:image_tag).with(avatar_mock).and_return 'avatar tag'
        expect(presenter.avatar).to eq 'avatar tag'
      end

      it "uses a generic avatar" do
        expect(presenter.ctx).to receive(:object_type).with(object).and_return :map
        expect(presenter.ctx).to receive(:icon).with(:globe).and_return 'globe icon'
        expect(presenter.avatar).to eq 'globe icon'
        expect(presenter.ctx).to receive(:object_type).with(object).and_return :data
        expect(presenter.ctx).to receive(:icon).with(:'map-marker').and_return 'marker icon'
        expect(presenter.avatar).to eq 'marker icon'
        expect(presenter.ctx).to receive(:object_type).with(object).and_return :user
        expect(presenter.ctx).to receive(:icon).with(:user).and_return 'user icon'
        expect(presenter.avatar).to eq 'user icon'
        expect(presenter.ctx).to receive(:object_type).with(object).and_return :foo
        expect(presenter.ctx).to receive(:icon).with(:question).and_return 'question icon'
        expect(presenter.avatar).to eq 'question icon'
      end
    end

    describe "#controls" do
      describe "with follow button" do
        let(:presenter_) { ListItemPresenter.new object: object, ctx: double('ctx'), control_type: :follow_button }
        it "renders follow button for objects" do
          expect(presenter_.ctx).to receive(:current_user).and_return double('current_user')
          expect(presenter_.ctx).to receive(:render).with('shared/follow_button', anything()).and_return 'follow button tag'
          expect(presenter_.controls).to eq 'follow button tag'
        end
        it "renders no button for the current user" do
          expect(presenter_.ctx).to receive(:current_user).and_return object
          expect(presenter_.controls).to eq nil
        end
      end

      describe "with counters" do
        let(:presenter_) { ListItemPresenter.new object: object, ctx: double('ctx'), control_type: :counters }
        it "renders counters" do
          expect(presenter_.ctx).to receive(:render).with('shared/counters', anything()).and_return 'counters tag'
          expect(presenter_.controls).to eq 'counters tag'
        end
      end

      describe "with default" do
        let(:presenter_) { ListItemPresenter.new object: object, ctx: double('ctx') }
        it "renders counters" do
          expect(presenter_.ctx).to receive(:render).with('shared/counters', anything()).and_return 'counters tag'
          expect(presenter_.controls).to eq 'counters tag'
        end
      end
    end
  end

  context "size is small" do
    let(:presenter) { ListItemPresenter.new object: object, ctx: double('ctx'), size: :small }
    it "displays no tags" do
      expect(presenter.tags).to eq nil
    end

    it "truncates big titles" do
      expect(presenter.ctx).to receive(:strip_tags).and_return 'stripped'
      expect(presenter.ctx).to receive(:truncate).with('stripped', length: 55).and_return 'truncated'
      expect(presenter.title).to eq 'truncated'
    end

    it "truncates big titles" do
      expect(presenter.ctx).to receive(:strip_tags).and_return 'stripped'
      expect(presenter.ctx).to receive(:truncate).with('stripped', length: 55).and_return 'truncated'
      expect(presenter.title).to eq 'truncated'
    end

    it "truncates big descriptions" do
      expect(presenter.ctx).to receive(:strip_tags).and_return 'stripped'
      expect(presenter.ctx).to receive(:truncate).with('stripped', length: 130).and_return 'truncated'
      expect(presenter.description).to eq 'truncated'
    end
  end

  context "size is medium" do
    let(:presenter) { ListItemPresenter.new object: object, ctx: double('ctx'), size: :medium }
    it "displays no tags" do
      expect(presenter.tags).to eq nil
    end

    it "truncates big titles" do
      expect(presenter.ctx).to receive(:strip_tags).and_return 'stripped'
      expect(presenter.ctx).to receive(:truncate).with('stripped', length: 85).and_return 'truncated'
      expect(presenter.title).to eq 'truncated'
    end

    it "truncates big descriptions" do
      expect(presenter.ctx).to receive(:strip_tags).and_return 'stripped'
      expect(presenter.ctx).to receive(:truncate).with('stripped', length: 300).and_return 'truncated'
      expect(presenter.description).to eq 'truncated'
    end
  end

  context "size is big" do
    let(:presenter) { ListItemPresenter.new object: object, ctx: double('ctx'), size: :big }
    it "displays tags" do
      allow(presenter.ctx).to receive(:render).and_return('rendered')
      expect(presenter.tags).to eq 'rendered'
    end

    it "truncates big titles" do
      expect(presenter.ctx).to receive(:strip_tags).and_return 'stripped'
      expect(presenter.ctx).to receive(:truncate).with('stripped', length: 85).and_return 'truncated'
      expect(presenter.title).to eq 'truncated'
    end

    it "truncates big descriptions" do
      expect(presenter.ctx).to receive(:strip_tags).and_return 'stripped'
      expect(presenter.ctx).to receive(:truncate).with('stripped', length: 300).and_return 'truncated'
      expect(presenter.description).to eq 'truncated'
    end
  end
end
