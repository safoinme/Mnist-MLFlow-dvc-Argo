import mlflow
from mlflow.entities import ViewType
from mlflow.tracking import MlflowClient
from distutils.dir_util import copy_tree
import os 

def main():
    #Initialize the mlflow client to get the artifact
    client = MlflowClient()
    #Set the expirement by name
    experiment = mlflow.get_experiment_by_name("mnist-example")     

    #Get infos about runs such as stage of the run and validation accuracy, and return the best run id
    def print_auto_logged_info(run_infos):
        best_run = None
        for r in run_infos:
            print("- run_id: {}, lifecycle_stage: {}".format(r.run_id, r.lifecycle_stage))
            print("val_accuracy : ", mlflow.get_run(r.run_id).data.metrics['val_accuracy'])         
            best_run = r.run_id
        return best_run

    #Return the best val accuracy run of The choosen exepiremnt
    best_run = print_auto_logged_info(mlflow.list_run_infos(experiment.experiment_id, run_view_type=ViewType.ALL, max_results=1, order_by=["metric.val_accuracy DESC"]))
    #df = mlflow.search_runs([experiment_id], order_by=["metrics.m DESC"]) we can do same using this function
    
    #We gonna create a tmp folder to store the artifacts into
    local_dir = "/tmp/artifact_downloads"
    #local_dir = os.path.join(os.getcwd(), "tmp" )
    if not os.path.exists(local_dir):
        os.mkdir(local_dir)

    #Get the model Artifact from the storage bucket 
    local_path = client.download_artifacts(best_run, "model", local_dir)

    models_dir = "/tmp/mnist-example/1/"
    #local_dir = os.path.join(os.getcwd(), "tmp" )
    if not os.path.exists(models_dir):
        os.makedirs(models_dir)

    copy_tree("/tmp/artifact_downloads/model/data/model", models_dir)
    #print("Artifacts downloaded in: {}".format(local_path))
    #print("Artifacts: {}".format(os.listdir(local_path)))

if __name__ == '__main__':
    #mlflow.mlflow.set_tracking_uri("http://127.0.0.1:5000")
    main()