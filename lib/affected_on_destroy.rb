

module AffectedOnDestroy

  def self.included(klass)
    klass.extend ClassMethods
  end


  module ClassMethods
    def dependent_associations
      associations = self.reflect_on_all_associations(:has_many) + self.reflect_on_all_associations(:has_one)
      associations.select {|a| a.options.has_key?(:dependent)}
    end


    # TODO: infinite recursion: create array already_inspected_associations
    # User.affected_on_destroy   # => ["Post", "Comments", "Ratings"]
    def affected_on_destroy
      returning affected = [] do
        dependent_associations.map do |assoc|
          affected << assoc.class_name
          affected << assoc.class_name.constantize.affected_on_destroy
        end
      end.flatten.uniq.sort
    end
  end


  # u = User.first
  # u.affected_on_destroy   # => [ #<Post id: 25>, #<Comment id: 10, post_id: 25>, #<Rating id: 3, post_id: 25>]
  def affected_on_destroy
    affected_objects = []
      self.class.dependent_associations.each do |assoc|
        next if (associated_relation = self.send(assoc.name)).blank?
        if assoc.macro == :has_one
          affected_objects << associated_relation
          affected_objects << associated_relation.affected_on_destroy
        elsif assoc.macro == :has_many
          associated_relation.each do |associated_object|
            affected_objects << associated_object 
            affected_objects << associated_object.affected_on_destroy
          end
        end
      end

    affected_objects.flatten.uniq.sort_by {|elem| elem.class.to_s }
  end

end


ActiveRecord::Base.send :include, AffectedOnDestroy
