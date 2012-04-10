module ActiveRecord
  class Base
    def to_map( include_related = false )
      attrs = attributes
      reflections.each do | key , reflection |
        associated = send key
        case
        when reflection.collection?
          attrs[ key ] = associated.map { | related | related.attributes }
        else
          attrs[ key ] = associated.attributes
        end
      end if include_related
      Map.new attrs
    end
  end
end
