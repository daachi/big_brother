require 'forwardable'

module BigBrother
  class ClusterCollection
    extend Forwardable
    def_delegators :@clusters, :[], :[]=, :size, :clear

    def initialize
      @clusters = {}
    end

    def config(new_clusters)
      (@clusters.keys - new_clusters.keys).each do |removed_name|
        @clusters.delete(removed_name).stop_monitoring!
      end
      new_clusters.each do |cluster_name, cluster|
        if @clusters.key?(cluster_name)
          @clusters[cluster_name] = cluster.incorporate_state(@clusters[cluster_name])
        else
          @clusters[cluster_name] = cluster
        end
      end
    end

    def running
      @clusters.values.select(&:monitored?)
    end

    def stopped
      @clusters.values.reject(&:monitored?)
    end

    def ready_for_check
      @clusters.values.select(&:needs_check?)
    end
  end
end
