module PostgresExt::Postgis::Arel::Visitors::PostgreSQL
  private

  def visit_Arel_Nodes_Contains(o, a = nil)
    left_column = o.left.relation.engine.columns.find { |col| col.name == o.left.name.to_s }

    if left_column.type == :geometry
      "ST_CONTAINS(#{visit o.left, a}, #{visit o.right, o.left})"
    else
      super
    end
  end

  def visit_RGeo_Feature_Instance(node, attribute = nil)
    quote(node, column_for(attribute))
  end
end
