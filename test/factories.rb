Factory.define :tache do |tache|
  tache.description "tache"
  tache.date_entree Time.now
end

Factory.define :tag do |tag|
  tag.description "tag"
end

Factory.define :etiquetage do |etiquetage|
  etiquetage.association :tag
  etiquetage.association :tache
end

Factory.define :projet do |projet|
  
end