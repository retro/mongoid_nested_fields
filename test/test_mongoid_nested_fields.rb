# encoding: utf-8

require 'helper'

class TestMongoidNestedFields < Test::Unit::TestCase
  context "MongoidNestedFields" do
    setup do
      Mongoid.configure do |config|
        name = "mongoid_content_block_development"
        host = "localhost"
        config.master = Mongo::Connection.new.db(name)
        config.persist_in_safe_mode = false
      end
    
      class ContentItem
        include Mongoid::Document
        nested_field :paragraph, :allowed_types => [String, Hash]
      end
      ContentItem.destroy_all
    end
  
    context "Class that includes Mongoid::Document" do
  
      should "have nested_field class method" do
        assert ContentItem.respond_to?(:nested_field)
      end
    
      should "correctly set field via nested_field" do
        c = ContentItem.new
        assert c.respond_to?(:paragraph)
      end
    
      should "set nested_field as MongoidNestedFields::NestedFieldHolder" do
        assert_equal ContentItem.fields['paragraph'].type, MongoidNestedFields::NestedFieldHolder
      end
    
      should_raise MongoidNestedFields::Errors::UnexpectedType do
        # Test if we can put unexpected type in value array
        c = ContentItem.new
        c.paragraph = [1]
      end
      
      should_raise TypeError do
        c = ContentItem.new
        c.paragraph = {:k => 'v'}
      end
    
      should "set nested_field to array of values with allowed types" do
        c = ContentItem.new
        c.paragraph = ["String", {'k' => 'Value'}]
        assert_equal c.paragraph, ["String", {'k' => 'Value'}]
      end
    
      should "set nested_field from JSON" do
        c = ContentItem.new
        c.paragraph = "[\"String\",{\"k\":\"Value\"}]"
        assert_equal c.paragraph, ["String", {'k' => 'Value'}]
      end
    
      should "use correct class to set value if _type attribute is present" do
        
        class ::ImageWithCaption
          include MongoidNestedFields::NestedField
          field :image
          field :caption
          def image
            read_attribute('image').upcase
          end
          def caption
            read_attribute('caption').upcase
          end
        end
        
        ContentItem.nested_field :image_with_caption, :allowed_types => [ImageWithCaption]
        c = ContentItem.new
        c.image_with_caption = [
          {'_type' => 'ImageWithCaption', :image => 'Image', :caption => 'Caption'}
        ]
        c.save
        
        assert_equal c.image_with_caption.first.class, ::ImageWithCaption
      end
      should "allow of nesting content fields and content field parts" do
        class ::Image
          include MongoidNestedFields::NestedField
          field :image
          
          def image
            read_attribute('image').upcase
          end
          
        end
        
        class ::ImageGallery
          include MongoidNestedFields::NestedField
          nested_field :gallery, :allowed_types => [Image]
          field :gallery_name
        end
        
        ContentItem.nested_field :gallery, :allowed_types => [ImageGallery]
        c = ContentItem.new
        c.gallery = [{
          '_type' => 'image_gallery',
          'gallery_name' => 'Test',
          :gallery => [
            {:_type => 'image', :image => 'img'}
          ]
        }]
        
        assert_equal c.gallery.first.to_mongo, {
                                  '_type' => 'image_gallery',
                                  'gallery_name' => 'Test',
                                  'gallery' => [
                                    {'_type' => 'image', 'image' => 'IMG'}
                                  ]
                                }
        
      end
      
      should "validate each content field" do
        class ::ParagraphWithTitle
          include MongoidNestedFields::NestedField
          field :title
          field :paragraph
          
          validates_presence_of :paragraph
        end
        
        ContentItem.nested_field :paragraph_with_title, :allowed_types => [ParagraphWithTitle]
        c = ContentItem.new
        c.paragraph_with_title = [{
          :_type => 'paragraph_with_title',
          :title => 'Title'
        }]
        c.invalid?
        assert c.invalid?
      end
      
      should "validate nested fields" do
        class ::Para
          include MongoidNestedFields::NestedField
          field :para
          field :subtitle
          validates_presence_of :para
        end
        class ::Title
          include MongoidNestedFields::NestedField
          field :title
          nested_field :paragraph, :allowed_types => [Para]
        end
        
        ContentItem.nested_field :test_para_title, :allowed_types => [Title]
        
        c = ContentItem.new(:test_para_title => [{
          '_type' => 'title',
          :title => 'Title',
          :paragraph => [{
            '_type' => 'para',
            :subtitle => 'Subtitle'
          }]
        }])
        
        assert c.invalid?
      end
      
      should "load correctly from database" do
        class ::ParagraphWithTitle
          include MongoidNestedFields::NestedField
          field :title
          field :paragraph
        
          validates_presence_of :paragraph
        end
      
        ContentItem.destroy_all
      
        ContentItem.nested_field :paragraph_with_title, :allowed_types => [ParagraphWithTitle]
        c = ContentItem.new
        c.paragraph_with_title = [{
          :_type => 'paragraph_with_title',
          :title => 'Title',
          :paragraph => 'Para'
        }]
        
        c.save
        
        document = ContentItem.first
        
        assert_equal document.paragraph_with_title.first.class, ::ParagraphWithTitle
        
      end
      
      should "return options for field definitions" do
        class ::ParagraphWithTitle
          include MongoidNestedFields::NestedField
          field :title, :custom_option => 'custom'
          field :paragraph
          nested_field :test_hash, :allowed_types => [Hash]
        end
        field_options = ::ParagraphWithTitle.field_options
        assert_equal field_options, {
                                      :title => {:custom_option => 'custom'},
                                      :paragraph => {},
                                      :test_hash => {:nested => true, :allowed_types => [Hash]}
                                    }
      end
      
      should "allow access through []" do
        class ::ParagraphWithTitle
          include MongoidNestedFields::NestedField
          field :title, :custom_option => 'custom'
          field :paragraph
        end
        
        p = ParagraphWithTitle.new(:title => 'test')
        assert_equal p['title'], 'test'
      end
      
      should_raise do
        class ::ParagraphWithTitle
          include MongoidNestedFields::NestedField
          field :title, :custom_option => 'custom'
          field :paragraph
        end
        p = ParagraphWithTitle.new
        p['non_existing_attr']
      end
      
    end
  end
end
